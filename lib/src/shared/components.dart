import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';

class Controller extends Component {
  bool up, down, left, right;
  bool upleft, upright, downleft, downright;
  bool space;

  Controller(
      {this.up = false,
      this.down = false,
      this.left = false,
      this.right = false,
      this.upleft = false,
      this.upright = false,
      this.downleft = false,
      this.downright = false,
      this.space = false});

  void reset() {
    up = false;
    down = false;
    left = false;
    right = false;
    upleft = false;
    upright = false;
    downleft = false;
    downright = false;
    space = false;
  }
}

class Acceleration extends Component {
  double value;
  double angle;
  Acceleration(this.value, this.angle);

  void addAcceleration(double value, double angle) {
    final x = this.value * cos(this.angle) + value * cos(angle);
    final y = this.value * sin(this.angle) + value * sin(angle);
    this.angle = atan2(y, x);
    this.value = sqrt(y * y + x * x);
  }
}

class Velocity extends Component {
  double value;
  double angle;
  Velocity(this.value, this.angle);

  void addVelocity(double value, double angle) {
    final x = this.value * cos(this.angle) + value * cos(angle);
    final y = this.value * sin(this.angle) + value * sin(angle);
    this.angle = atan2(y, x);
    this.value = sqrt(y * y + x * x);
  }
}

class Car extends Component {}

class OnTrack extends Component {}

class Track extends Component {
  TrackDirection direction;
  Track(this.direction);
}

class TrackDestroyer extends Component {}

class TrackConfig {
  double yOffset;
  List<DirectionConfig> directionConfigs;
  TrackConfig(this.yOffset, this.directionConfigs);
}

class Falling extends Component {}

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
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
      ]);
      break;
    case TrackDirection.straightToUpwards:
      result = TrackConfig(carHeightHalf, [
        DirectionConfig(TrackDirection.upwards, 0.9),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.1),
      ]);
      break;
    case TrackDirection.upwards:
      result = TrackConfig(carHeight, [
        DirectionConfig(TrackDirection.upwards, 0.8),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.2),
      ]);
      break;
    case TrackDirection.upwardsToStraight:
      result = TrackConfig(carHeightHalf, [
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
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
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
      ]);
      break;
    case TrackDirection.straightToMissing:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.missing, 1.0),
      ]);
      break;
    case TrackDirection.upwardsToMissing:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.missing, 1.0),
      ]);
      break;
    case TrackDirection.missing:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.missingToStraight, 0.75),
        DirectionConfig(TrackDirection.missingToDownwards, 0.25),
      ]);
      break;
    case TrackDirection.missingToStraight:
      result = TrackConfig(-carHeightHalf, [
        DirectionConfig(TrackDirection.straight, 1.0),
      ]);
      break;
    case TrackDirection.missingToDownwards:
      result = TrackConfig(-carHeight, [
        DirectionConfig(TrackDirection.downwards, 1.0),
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
