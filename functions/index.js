/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMatchNotification = functions.firestore
    .document("matches/{match_id}")
    .onCreate(async (snap, context) => {
      const value = snap.data();
      const businessId = value.business;
      const clubId = value.club;

      const clubPromise = admin.firestore().doc(`users/${clubId}`).get();
      const club = await clubPromise;

      const businessPromise = admin.firestore().doc(`users/${businessId}`).get();
      const business = await businessPromise;

      const tokens = club.data().notification_token;
      if (tokens.length == 0) {
        return functions.logger.log("There are no notification tokens to send to");
      }

      const name = business.data().name;
      const imageUrl = business.data().profile_images[0];

      const payload = {
        notification: {
          title: "You have a new match!",
          body: `${name} matched with you!`,
          icon: imageUrl,
        },
        data: {
          name: name,
          profile_image_url: imageUrl,
          user_id: businessId,
        },
      };

      await admin.firestore().doc(`users/${businessId}`).update({
        newMatches: admin.firestore().FieldValue.arrayUnion(value.id),
      });


      const response = await admin.messaging().sendToDevice(tokens, payload);
      await cleanupTokens(response, tokens, clubId);
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          functions.logger.error(
              "Failure sending notification to",
              tokens[index],
              error,
          );
        } else {
          functions.logger.log("Notification sent to " + tokens[index]);
        }
      });
    });

exports.sendNewPitchNotification = functions.firestore
    .document("pitches/{pitch_id}")
    .onCreate(async (snap, context) => {
      const value = snap.data();

      const senderId = value.sender_id;
      const sender = await admin.firestore().doc(`users/${senderId}`).get();

      const receiverId = value.receiver_id;
      const receiver = await admin.firestore().doc(`users/${receiverId}`).get();

      const tokens = receiver.data().notification_token;
      if (tokens.length == 0) {
        return functions.logger.log("There are no notification tokens to send to");
      }

      const payload = {
        notification: {
          title: "You have a new pitch!",
          body: `${sender.data().name} sent you their pitch!`,
          icon: sender.data().profile_images[0],
        },
      };

      const response = await admin.messaging().sendToDevice(tokens, payload);
      await cleanupTokens(response, tokens, receiverId);
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          functions.logger.error(
              "Failure sending notification to",
              tokens[index],
              error,
          );
        } else {
          functions.logger.log("Notification sent to " + tokens[index]);
        }
      });
    });

exports.sendNewMessageNotification = functions.firestore
    .document("messages/{message_id}")
    .onCreate(async (snap, context) => {
      const value = snap.data();

      const chatId = value.chat_id;
      const message = value.content;
      const userType = value.sent_by_user_type;

      const chat = await admin.firestore().doc(`chats/${chatId}`).get();

      let receiverId;
      let senderId;
      if (userType == "club") {
        receiverId = chat.data().business;
        senderId = chat.data().club;
      } else {
        receiverId = chat.data().club;
        senderId = chat.data().business;
      }

      const sender = await admin.firestore().doc(`users/${senderId}`).get();
      const receiver = await admin.firestore().doc(`users/${receiverId}`).get();
      const tokens = receiver.data().notification_token;

      if (tokens.length == 0) {
        return functions.logger.log("There are no notification tokens to send to");
      }

      const payload = {
        notification: {
          title: `${sender.data().name}`,
          body: `${message}`,
          icon: sender.data().profile_images[0],
        },
      };

      const response = await admin.messaging().sendToDevice(tokens, payload);
      await cleanupTokens(response, tokens, receiverId);
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          functions.logger.error(
              "Failure sending notification to",
              tokens[index],
              error,
          );
        } else {
          functions.logger.log("Notification sent to " + tokens[index]);
        }
      });
    });

/**
 * Cleans up tokens no longer valid
 * @param {number} response The first number.
 * @param {number} tokens The second number.
 * @param {number} userId The second number.
 * @return {number} The sum of the two numbers.
 */
function cleanupTokens(response, tokens, userId) {
  const tokensDelete = [];
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
      console.error("Failure sending notification to", tokens[index], error);
      // Cleanup the tokens who are not registered anymore.
      if (error.code === "messaging/invalid-registration-token" ||
          error.code === "messaging/registration-token-not-registered") {
        const deleteTask = admin.firestore().doc(`users/${userId}`).update({
          notificationToken: admin.firestore().FieldValue.arrayRemove(tokens[index]),
        });
        tokensDelete.push(deleteTask);
      }
    }
  });
  return Promise.all(tokensDelete);
}
