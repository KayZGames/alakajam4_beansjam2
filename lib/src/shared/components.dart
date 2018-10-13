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

class Car extends Component {}

class Track extends Component {
  TrackDirection direction;
  Track(this.direction);
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

class DirectionConfig {
  TrackDirection direction;
  double probablility;
  DirectionConfig(this.direction, this.probablility);
}

Map<TrackDirection, List<DirectionConfig>> directionConfigs =
    Map.fromIterable(TrackDirection.values, value: _generateConfig);

List<DirectionConfig> _generateConfig(dynamic direction) {
  final result = <DirectionConfig>[];
  switch (direction as TrackDirection) {
    case TrackDirection.straight:
      result.addAll([
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
      ]);
      break;
    case TrackDirection.straightToUpwards:
      result.addAll([
        DirectionConfig(TrackDirection.upwards, 0.9),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.1),
      ]);
      break;
    case TrackDirection.upwards:
      result.addAll([
        DirectionConfig(TrackDirection.upwards, 0.8),
        DirectionConfig(TrackDirection.upwardsToStraight, 0.2),
      ]);
      break;
    case TrackDirection.upwardsToStraight:
      result.addAll([
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
      ]);
      break;
    case TrackDirection.straightToDownwards:
      result.addAll([
        DirectionConfig(TrackDirection.downwards, 0.9),
        DirectionConfig(TrackDirection.downwardsToStraight, 0.1),
      ]);
      break;
    case TrackDirection.downwards:
      result.addAll([
        DirectionConfig(TrackDirection.downwards, 0.8),
        DirectionConfig(TrackDirection.downwardsToStraight, 0.2),
      ]);
      break;
    case TrackDirection.downwardsToStraight:
      result.addAll([
        DirectionConfig(TrackDirection.straight, 0.8),
        DirectionConfig(TrackDirection.straightToUpwards, 0.1),
        DirectionConfig(TrackDirection.straightToDownwards, 0.1)
      ]);
      break;
    case TrackDirection.straightToMissing:
      result.addAll([
        DirectionConfig(TrackDirection.missing, 1.0),
      ]);
      break;
    case TrackDirection.upwardsToMissing:
      result.addAll([
        DirectionConfig(TrackDirection.missing, 1.0),
      ]);
      break;
    case TrackDirection.missing:
      result.addAll([
        DirectionConfig(TrackDirection.missingToStraight, 0.75),
        DirectionConfig(TrackDirection.missingToDownwards, 0.25),
      ]);
      break;
    case TrackDirection.missingToStraight:
      result.addAll([
        DirectionConfig(TrackDirection.straight, 1.0),
      ]);
      break;
    case TrackDirection.missingToDownwards:
      result.addAll([
        DirectionConfig(TrackDirection.downwards, 1.0),
      ]);
      break;
  }
  final totalProbability =
      result.fold(0, (sum, config) => sum + config.probablility);
  assert(totalProbability == 1.0,
      'total probability for $direction is $totalProbability');
  return result;
}
