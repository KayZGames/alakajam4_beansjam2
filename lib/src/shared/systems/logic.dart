import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:alakajam4_beansjam2/src/shared/components.dart';

part 'logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: const [
    Controller,
    Acceleration,
  ],
)
class ControllerToActionSystem extends _$ControllerToActionSystem {
  final _acc = 20.0;

  @override
  void processEntity(Entity entity) {
    final controller = controllerMapper[entity];
    final acceleration = accelerationMapper[entity];
    if (controller.left) {
      acceleration.x -= _acc;
    } else if (controller.right) {
      acceleration.x += _acc;
    }
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Orientation,
    Mass,
  ],
)
class GravitySystem extends _$GravitySystem {
  @override
  void processEntity(Entity entity) {
    final angle = orientationMapper[entity].angle;
    accelerationMapper[entity]
      ..x += sin(angle + pi) * 9.81
      ..y -= 9.81;
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Velocity,
  ],
)
class AccelerationSystem extends _$AccelerationSystem {
  @override
  void processEntity(Entity entity) {
    final acceleration = accelerationMapper[entity];
    var velocity = velocityMapper[entity];
    velocity
      ..x += acceleration.x * world.delta
      ..y += acceleration.y * world.delta;
    velocity.x = min(50.0, max(10.0, velocity.x));
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Velocity,
    Position,
    Orientation,
  ],
)
class MovementSystem extends _$MovementSystem {
  @override
  void processEntity(Entity entity) {
    final velocity = velocityMapper[entity];
    final angle = orientationMapper[entity].angle;
    positionMapper[entity]
      ..x += velocity.x * world.delta * cos(angle)
      ..y += velocity.y * world.delta;
  }
}

@Generate(
  EntitySystem,
  allOf: [
    Track,
  ],
)
class TrackSpawningSystem extends _$TrackSpawningSystem {
  double lastX = -50.0;
  double lastY = -carHeightHalf - trackHeightHalf;
  TrackDirection lastDirection = TrackDirection.straight;
  double randomNumber = 0.0;
  Map<int, double> yPositions = <int, double>{};

  @override
  void processEntities(Iterable<Entity> entities) {
    for (var index = entities.length; index < 200; index++) {
      lastDirection = getNextDirection();
      world.createAndAddEntity(
          [Position(lastX.toDouble(), lastY.toDouble()), Track(lastDirection)]);
      lastX += trackWidthHalf * 2;
      lastY += getYOffset();
      yPositions[lastX.floor()] = lastY;
      print(yPositions);
    }
  }

  TrackDirection getNextDirection() {
    if (lastX < 10) {
      return TrackDirection.straight;
    }
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

  @override
  bool checkProcessing() => true;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Car,
    Position,
    Velocity,
    Orientation,
  ],
  systems: [
    TrackSpawningSystem,
  ],
)
class CarOnTrackSystem extends _$CarOnTrackSystem {
  @override
  void processEntity(Entity entity) {
    final position = positionMapper[entity];
    final orientation = orientationMapper[entity];
    final lastX = position.x.floor();
    final nextX = lastX + 1.0;
    final percentage = (position.x - lastX) / (nextX - lastX);
    final lastY = trackSpawningSystem.yPositions[lastX];
    final nextY = trackSpawningSystem.yPositions[nextX];
    final y = lastY * (1.0 - percentage) + nextY * percentage;
    ;

    position.y = y + carHeightHalf + trackHeightHalf;
    velocityMapper[entity].y = 0.0;

    final beforeLastY = trackSpawningSystem.yPositions[lastX - 1];
    final previousY = beforeLastY * (1.0 - percentage) + lastY * percentage;
    orientation.angle = atan2(y - previousY, nextX - lastX);

    position.y -= sin(orientation.angle) * (carHeightHalf + trackHeightHalf);
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Track,
    Position,
  ],
  systems: [
    TrackSpawningSystem,
  ],
  manager: [
    TagManager,
  ],
)
class TrackDespawningSystem extends _$TrackDespawningSystem {
  @override
  void processEntity(Entity entity) {
    final cameraX = positionMapper[tagManager.getEntity(cameraTag)].x.floor();
    final x = positionMapper[entity].x.floor();
    if (x < cameraX - 100) {
      entity.deleteFromWorld();
      trackSpawningSystem.yPositions.remove(x);
    }
  }
}
