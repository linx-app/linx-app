import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/utils/transformations/pitch_transformation_extensions.dart';

class SendRequestService {
  static final provider = Provider((ref) => SendRequestService(ref.read(PitchRepository.provider)));

  final PitchRepository _pitchRepository;

  SendRequestService(this._pitchRepository);

  Future<void> execute(Request request) async {
    var pitch = request.toNetwork();
    await _pitchRepository.sendPitch(pitch);
  }
}