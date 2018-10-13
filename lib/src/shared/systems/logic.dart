import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:alakajam4_beansjam2/src/shared/components.dart';

part 'logic.g.dart';

@Generate(EntityProcessingSystem, allOf: const [Controller, Acceleration])
class ControllerToActionSystem extends _$ControllerToActionSystem {
  final _acc = 50.0;
  final _sqrttwo = 1.4142;

  @override
  void processEntity(Entity entity) {
    final controller = controllerMapper[entity];
    final acceleration = accelerationMapper[entity];
    if (controller.up) {
      acceleration.y += _acc * world.delta;
    } else if (controller.down) {
      acceleration.y -= _acc * world.delta;
    } else if (controller.left) {
      acceleration.x -= _acc * world.delta;
    } else if (controller.right) {
      acceleration.x += _acc * world.delta;
    } else if (controller.upleft) {
      acceleration.y += _acc * world.delta / _sqrttwo;
      acceleration.x -= _acc * world.delta / _sqrttwo;
    } else if (controller.upright) {
      acceleration.y += _acc * world.delta / _sqrttwo;
      acceleration.x += _acc * world.delta / _sqrttwo;
    } else if (controller.downleft) {
      acceleration.y -= _acc * world.delta / _sqrttwo;
      acceleration.x -= _acc * world.delta / _sqrttwo;
    } else if (controller.downright) {
      acceleration.y -= _acc * world.delta / _sqrttwo;
      acceleration.x += _acc * world.delta / _sqrttwo;
    }
  }
}

@Generate(
  EntitySystem,
  allOf: [
    Track,
  ],
)
class TrackSpawningSystem extends _$TrackSpawningSystem {
  double lastX = 0.0;
  double lastY = -carHeightHalf - trackHeightHalf;
  TrackDirection lastDirection = TrackDirection.straight;
  double randomNumber = 0.0;
  @override
  bool checkProcessing() => true;

  @override
  void processEntities(Iterable<Entity> entities) {
    for (var index = entities.length; index < 50; index++) {
      lastDirection = getNextDirection();
      world.createAndAddEntity(
          [Position(lastX.toDouble(), lastY.toDouble()), Track(lastDirection)]);
      lastX += trackWidthHalf * 2;
      lastY += getYOffset();
    }
  }

  TrackDirection getNextDirection() {
    final configs = directionConfigs[lastDirection];
    randomNumber = (randomNumber + random.nextDouble()) % 1.0;
    double configProbability = 0.0;
    int configIndex = 0;
    while (configIndex < configs.length) {
      configProbability += configs[configIndex].probablility;
      if (randomNumber < configProbability) {
        return configs[configIndex].direction;
      }
      configIndex++;
    }
    assert(false, '$lastDirection $configProbability != 1.0');
    return null;
  }

  double getYOffset() {
    switch (lastDirection) {
      case TrackDirection.straight:
        return 0.0;
      case TrackDirection.straightToUpwards:
        return carHeightHalf;
      case TrackDirection.upwards:
        return carHeightHalf * 2;
      case TrackDirection.upwardsToStraight:
        return carHeightHalf;
      case TrackDirection.straightToDownwards:
      case TrackDirection.straightToMissing:
      case TrackDirection.missingToDownwards:
      case TrackDirection.missingToStraight:
        return -carHeightHalf;
      case TrackDirection.downwards:
      case TrackDirection.missing:
      case TrackDirection.upwardsToMissing:
        return -carHeightHalf * 2;
      case TrackDirection.downwardsToStraight:
        return -carHeightHalf;
    }
    assert(false, 'missing case for $lastDirection');
    return 0.0;
  }
}
