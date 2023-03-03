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

      const payload = {
        notification: {
          title: "You have a new match!",
          body: `${business.data().name} matched with you!`,
          icon: business.data().profile_images[0],
        },
        data: {
          match_id: value.id,

        }
      };

      const response = await admin.messaging().sendToDevice(tokens, payload);
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          functions.logger.error(
              "Failure sending notification to",
              tokens[index],
              error,
          );
          // Cleanup the tokens who are not registered anymore.
          //   if (error.code === "messaging/invalid-registration-token" ||
          //                                 error.code === "messaging/registration-token-not-registered") {
          //     tokensToRemove.push(clubSnapshot.update({notification_tokens: admin.firestore.arrayRemove()}));
          //   }
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
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          functions.logger.error(
              "Failure sending notification to",
              tokens[index],
              error,
          );
          // Cleanup the tokens who are not registered anymore.
          //   if (error.code === "messaging/invalid-registration-token" ||
          //                                 error.code === "messaging/registration-token-not-registered") {
          //     tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
          //   }
        } else {
          functions.logger.log("Notification sent to " + tokens[index]);
        }
      });
    });
// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
