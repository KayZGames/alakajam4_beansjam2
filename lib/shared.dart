library shared;

import 'dart:math';

export 'package:gamedev_helpers/gamedev_helpers_shared.dart'
    hide Acceleration, Velocity, ResetAccelerationSystem;

export 'src/shared/components.dart';
export 'src/shared/systems/logic.dart';

const double carWidthHalf = 1.0;
const double carHeight = 1.0;
const double carHeightHalf = carHeight / 2;
final double vertexAngle = atan2(carHeightHalf, carWidthHalf);

const double trackWidth = 1.0;
const double trackWidthHalf = 0.5;
const double trackHeightHalf = 0.1;

bool isTrackMissing(TrackDirection trackDirection) {
  return trackDirection == TrackDirection.missing ||
      trackDirection == TrackDirection.missingToDownwards ||
      trackDirection == TrackDirection.missingToStraight ||
      trackDirection == TrackDirection.straightToMissing ||
      trackDirection == TrackDirection.upwardsToMissing;
}

enum TrackDirection {
  straight,
  straightToUpwards,
  upwards,
  upwardsToStraight,
  straightToDownwards,
  downwards,
  downwardsToStraight,
  straightToMissing,
  upwardsToMissing,
  missing,
  missingToStraight,
  missingToDownwards,
}

class TrackConfig {
  double yOffset;
  List<DirectionConfig> directionConfigs;
  TrackConfig(this.yOffset, this.directionConfigs);
}

class DirectionConfig {
  TrackDirection direction;
  double probablility;
  DirectionConfig(this.direction, this.probablility);
}

Map<TrackDirection, TrackConfig> trackConfigs =
    Map.fromIterable(TrackDirection.values, value: _generateConfig);

TrackConfig _generateConfig(dynamic direction) {
  TrackConfig result;
  switch (direction as TrackDirection) {
    case TrackDirection.straight:
      result = TrackConfig(0.0, [
        DirectionConfig(TrackDirection.straight, 0.775),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1),
        DirectionConfig(TrackDirection.straightToMissing, 0.025),
      ]);
      break;
    case TrackDirection.straightToUpwards:
      result = TrackConfig(carHeightHalf, [
        DirectionConfig(TrackDirection.upwards, 0.875),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.1),
        DirectionConfig(TrackDirection.upwardsToMissing, 0.025),
      ]);
      break;
    case TrackDirection.upwards:
      result = TrackConfig(carHeight, [
        DirectionConfig(TrackDirection.upwards, 0.775),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.2),
        DirectionConfig(TrackDirection.upwardsToMissing, 0.025),
      ]);
      break;
    case TrackDirection.upwardsToStraight:
      result = TrackConfig(carHeightHalf, [
        DirectionConfig(TrackDirection.straight, 0.775),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1),
        DirectionConfig(TrackDirection.straightToMissing, 0.025)
      ]);
      break;
    case TrackDirection.straightToDownwards:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.downwards, 0.9),
        DirectionConfig(TrackDirection.downwardsToStraight, 0.1),
      ]);
      break;
    case TrackDirection.downwards:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.downwards, 0.8),
        DirectionConfig(TrackDirection.downwardsToStraight, 0.2),
      ]);
      break;
    case TrackDirection.downwardsToStraight:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.straight, 0.75),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1),
        DirectionConfig(TrackDirection.straightToMissing, 0.05)
      ]);
      break;
    case TrackDirection.straightToMissing:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.missing, 0.7),
        DirectionConfig(TrackDirection.missingToStraight, 0.15),
        DirectionConfig(TrackDirection.missingToDownwards, 0.15),
      ]);
      break;
    case TrackDirection.upwardsToMissing:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.missing, 0.7),
        DirectionConfig(TrackDirection.missingToStraight, 0.15),
        DirectionConfig(TrackDirection.missingToDownwards, 0.15),
      ]);
      break;
    case TrackDirection.missing:
      result = TrackConfig(-carHeightHalf / 2, [
        DirectionConfig(TrackDirection.missing, 0.7),
        DirectionConfig(TrackDirection.missingToStraight, 0.15),
        DirectionConfig(TrackDirection.missingToDownwards, 0.15),
      ]);
      break;
    case TrackDirection.missingToStraight:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.straight, 0.5),
        DirectionConfig(TrackDirection.straightToDownwards, 0.25),
        DirectionConfig(TrackDirection.straightToUpwards, 0.25),
      ]);
      break;
    case TrackDirection.missingToDownwards:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.downwards, 0.5),
        DirectionConfig(TrackDirection.downwardsToStraight, 0.5),
      ]);
      break;
  }
  assert(result != null, 'missing case for $direction');
  final totalProbability = result.directionConfigs
      .fold(0, (sum, config) => sum + config.probablility);
  assert(totalProbability == 1.0,
      'total probability for $direction is $totalProbability');
  return result;
}
