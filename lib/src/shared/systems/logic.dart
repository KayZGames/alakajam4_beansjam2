import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart'
    hide Acceleration, Velocity;
import 'package:alakajam4_beansjam2/src/shared/components.dart';

part 'logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: const [
    Controller,
    Acceleration,
    Orientation,
  ],
  manager: [
    MagLockManager,
  ],
  mapper: [
    OnTrack,
  ],
)
class ControllerToActionSystem extends _$ControllerToActionSystem {
  final _acc = 20.0;

  @override
  void processEntity(Entity entity) {
    final controller = controllerMapper[entity];
    final acceleration = accelerationMapper[entity];
    final orientation = orientationMapper[entity];
    if (magLockManager.magLockActive && onTrackMapper.has(entity)) {
      if (controller.left) {
        acceleration.addAcceleration(_acc, orientation.angle + pi);
      } else if (controller.right) {
        acceleration.addAcceleration(_acc, orientation.angle);
      }
    }
    if (controller.space) {
      magLockManager.toggleMagLock();
    }
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Mass,
  ],
  exclude: [
    OnTrack,
  ],
  manager: [
    MagLockManager,
  ],
)
class GravitySystem extends _$GravitySystem {
  @override
  void processEntity(Entity entity) {
    accelerationMapper[entity].addAcceleration(9.81, -pi / 2);
    if (magLockManager.magLockActive) {
      accelerationMapper[entity].addAcceleration(20, -pi / 2);
    }
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Orientation,
    Mass,
    OnTrack,
  ],
  manager: [
    MagLockManager,
  ],
)
class OnTrackGravitySystem extends _$OnTrackGravitySystem {
  @override
  void processEntity(Entity entity) {
    final orientation = orientationMapper[entity];
    if (!magLockManager.magLockActive || orientation.angle < 0.0) {
      accelerationMapper[entity]
          .addAcceleration(-9.81 * sin(orientation.angle), orientation.angle);
    }
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Velocity,
  ],
  exclude: [
    OnTrack,
  ],
)
class AccelerationSystem extends _$AccelerationSystem {
  @override
  void processEntity(Entity entity) {
    final acceleration = accelerationMapper[entity];
    final velocity = velocityMapper[entity];
    velocity.addVelocity(acceleration.value * world.delta, acceleration.angle);
    velocity.value = min(50.0, max(10.0, velocity.value));
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
    Velocity,
    OnTrack,
    Orientation,
  ],
)
class OnTrackAccelerationSystem extends _$OnTrackAccelerationSystem {
  @override
  void processEntity(Entity entity) {
    final acceleration = accelerationMapper[entity];
    final velocity = velocityMapper[entity];
    velocity.addVelocity(acceleration.value * world.delta, acceleration.angle);
    velocity.angle = orientationMapper[entity].angle;
    velocity.value = min(50.0, max(10.0, velocity.value));
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Acceleration,
  ],
)
class ResetAccelerationSystem extends _$ResetAccelerationSystem {
  @override
  void processEntity(Entity entity) {
    accelerationMapper[entity]
      ..value = 0.0
      ..angle = 0.0;
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Velocity,
    Position,
  ],
)
class MovementSystem extends _$MovementSystem {
  @override
  void processEntity(Entity entity) {
    final velocity = velocityMapper[entity];
    positionMapper[entity]
      ..x += velocity.value * world.delta * cos(velocity.angle)
      ..y += velocity.value * world.delta * sin(velocity.angle);
  }
}

@Generate(
  EntitySystem,
  allOf: [
    Track,
  ],
)
class TrackSpawningSystem extends _$TrackSpawningSystem {
  double currentX = -50.0;
  double currentY = -carHeightHalf - trackHeightHalf;
  TrackDirection currentDirection = TrackDirection.straight;
  double randomNumber = 0.0;
  Map<int, double> yPositions = <int, double>{};
  Map<int, Entity> tracks = <int, Entity>{};

  @override
  void processEntities(Iterable<Entity> entities) {
    for (var index = entities.length; index < 200; index++) {
      currentDirection = getNextDirection();
      final track = world.createAndAddEntity([
        Position(currentX.toDouble(), currentY.toDouble()),
        Track(currentDirection)
      ]);
      tracks[currentX.floor()] = track;
      currentX += trackWidthHalf * 2;
      currentY += trackConfigs[currentDirection].yOffset;
      yPositions[currentX.floor()] = currentY;
    }
  }

  TrackDirection getNextDirection() {
    if (currentX < 10) {
      return TrackDirection.straight;
    }
    final configs = trackConfigs[currentDirection].directionConfigs;
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
    assert(false, '$currentDirection $configProbability != 1.0');
    return null;
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
  manager: [
    MagLockManager,
  ],
  mapper: [
    OnTrack,
  ],
)
class CarOnTrackSystem extends _$CarOnTrackSystem {
  @override
  void processEntity(Entity entity) {
    final position = positionMapper[entity];
    final orientation = orientationMapper[entity];
    final currentX = position.x.floor() + 1;
    final nextX = currentX + 1;
    final lastX = currentX - 1;
    final percentage = (position.x - lastX) / (nextX - currentX);
    final currentTrack = trackSpawningSystem.tracks[currentX];
    final nextTrack = trackSpawningSystem.tracks[nextX];
    final lastTrack = trackSpawningSystem.tracks[lastX] ?? currentTrack;
    final currentY = positionMapper[currentTrack].y;
    final nextY = positionMapper[nextTrack].y;
    final lastY = positionMapper[lastTrack].y;
    final averageY = currentY * (1.0 - percentage) + nextY * percentage;
    final lastAverageY = lastY * (1.0 - percentage) + currentY * percentage;
    final optimalY = averageY +
        carHeightHalf +
        trackHeightHalf -
        sin(orientation.angle) * (carHeightHalf + trackHeightHalf * 2);
    final maglockedAngle = atan2(averageY - lastAverageY, currentX - lastX);
    if (position.y < optimalY + trackHeightHalf &&
            position.y > optimalY - trackHeightHalf ||
        magLockManager.magLockActive && onTrackMapper.has(entity)) {
      final velocity = velocityMapper[entity];
      orientation.angle = maglockedAngle;
      position.y = optimalY;
      velocity.angle = maglockedAngle;
      entity
        ..addComponent(OnTrack())
        ..changedInWorld();
    } else if (position.y < optimalY) {
      final velocity = velocityMapper[entity];
      orientation.angle = maglockedAngle;
      position.y = optimalY;
      velocity
        ..value = velocity.value * cos(orientation.angle - velocity.angle)
        ..value = min(50.0, max(10.0, velocity.value))
        ..angle = maglockedAngle;
      entity
        ..addComponent(OnTrack())
        ..changedInWorld();
    } else {
      entity
        ..removeComponent<OnTrack>()
        ..changedInWorld();
    }
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
    final playerX = positionMapper[tagManager.getEntity(playerTag)].x.floor();
    final x = positionMapper[entity].x.floor();
    if (x < playerX - 100) {
      trackSpawningSystem..yPositions.remove(x + 1)..tracks.remove(x);
      entity.deleteFromWorld();
    }
  }
}

@Generate(
  VoidEntitySystem,
  mapper: [
    Position,
    Velocity,
  ],
  manager: [
    TagManager,
    CameraManager,
  ],
)
class CameraMovementSystem extends _$CameraMovementSystem {
  @override
  void processSystem() {
    final player = tagManager.getEntity(playerTag);
    final camera = tagManager.getEntity(cameraTag);
    final cameraPosition = positionMapper[camera];
    final playerPosition = positionMapper[player];
    final velocity = velocityMapper[player];
    final smoothingFactor = 0.9 * world.delta;
    cameraPosition
      ..x = cameraPosition.x * (1 - smoothingFactor) +
          smoothingFactor * (playerPosition.x + sqrt(velocity.value - 5.0) * 10)
      ..y = playerPosition.y;
    cameraManager.gameZoom = cameraManager.gameZoom * (1 - smoothingFactor) +
        smoothingFactor * sqrt(velocity.value) / 50;
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    TrackDestroyer,
    Position,
  ],
  systems: [
    TrackSpawningSystem,
  ],
)
class TrackDestroyerSystem extends _$TrackDestroyerSystem {
  @override
  void processEntity(Entity entity) {
    final x = positionMapper[entity].x.floor();
    final track = trackSpawningSystem.tracks.remove(x);
    track?.deleteFromWorld();
    trackSpawningSystem.yPositions.remove(x + 1);
  }
}

class MagLockManager extends Manager {
  bool magLockActive = true;

  void toggleMagLock() {
    magLockActive = !magLockActive;
  }
}
