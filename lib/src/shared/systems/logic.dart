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
  systems: [
    CarOnTrackSystem,
  ],
)
class ControllerToActionSystem extends _$ControllerToActionSystem {
  final _acc = 20.0;

  @override
  void processEntity(Entity entity) {
    final controller = controllerMapper[entity];
    final acceleration = accelerationMapper[entity];
    final orientation = orientationMapper[entity];
    if (controller.left) {
      acceleration.addAcceleration(_acc, orientation.angle + pi);
    } else if (controller.right) {
      acceleration.addAcceleration(_acc, orientation.angle);
    }
    if (controller.space) {
      carOnTrackSystem.maglockActive = !carOnTrackSystem.maglockActive;
      if (carOnTrackSystem.maglockActive) {
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
)
class GravitySystem extends _$GravitySystem {
  @override
  void processEntity(Entity entity) {
    accelerationMapper[entity].addAcceleration(9.81, -pi / 2);
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
)
class OnTrackGravitySystem extends _$OnTrackGravitySystem {
  @override
  void processEntity(Entity entity) {
    final orientation = orientationMapper[entity];
    accelerationMapper[entity]
        .addAcceleration(-9.81 * sin(orientation.angle), orientation.angle);
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
    OnTrack,
  ],
  systems: [
    TrackSpawningSystem,
  ],
)
class CarOnTrackSystem extends _$CarOnTrackSystem {
  bool maglockActive = true;

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
    orientation.angle = atan2(averageY - lastAverageY, currentX - lastX);
    position.y = averageY +
        carHeightHalf +
        trackHeightHalf -
        sin(orientation.angle) * (carHeightHalf + trackHeightHalf * 2);
  }

  @override
  bool checkProcessing() => maglockActive;
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
    var velocity = velocityMapper[player];
    final playerVelX = velocity.value * cos(velocity.angle);
    cameraPosition
      ..x = playerPosition.x + sqrt((playerVelX) * 10)
      ..y = playerPosition.y;
    cameraManager.gameZoom = sqrt(playerVelX) / 50;
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
