// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$ControllerToActionSystem extends EntityProcessingSystem {
  Mapper<Controller> controllerMapper;
  Mapper<Acceleration> accelerationMapper;
  Mapper<Orientation> orientationMapper;
  Mapper<OnTrack> onTrackMapper;
  MagLockManager magLockManager;
  _$ControllerToActionSystem()
      : super(Aspect.empty()..allOf([Controller, Acceleration, Orientation]));
  @override
  void initialize() {
    super.initialize();
    controllerMapper = Mapper<Controller>(world);
    accelerationMapper = Mapper<Acceleration>(world);
    orientationMapper = Mapper<Orientation>(world);
    onTrackMapper = Mapper<OnTrack>(world);
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$GravitySystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Mass> massMapper;
  MagLockManager magLockManager;
  _$GravitySystem()
      : super(Aspect.empty()
          ..allOf([Acceleration, Mass])
          ..exclude([OnTrack]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    massMapper = Mapper<Mass>(world);
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$MagneticForceSystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Car> carMapper;
  MagLockManager magLockManager;
  _$MagneticForceSystem()
      : super(Aspect.empty()
          ..allOf([Acceleration, Car])
          ..exclude([OnTrack, Falling]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    carMapper = Mapper<Car>(world);
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$OnTrackGravitySystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Orientation> orientationMapper;
  Mapper<Mass> massMapper;
  Mapper<OnTrack> onTrackMapper;
  MagLockManager magLockManager;
  GameStateManager gameStateManager;
  _$OnTrackGravitySystem()
      : super(
            Aspect.empty()..allOf([Acceleration, Orientation, Mass, OnTrack]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    orientationMapper = Mapper<Orientation>(world);
    massMapper = Mapper<Mass>(world);
    onTrackMapper = Mapper<OnTrack>(world);
    magLockManager = world.getManager<MagLockManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$AccelerationSystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Velocity> velocityMapper;
  _$AccelerationSystem()
      : super(Aspect.empty()
          ..allOf([Acceleration, Velocity])
          ..exclude([OnTrack]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    velocityMapper = Mapper<Velocity>(world);
  }
}

abstract class _$OnTrackAccelerationSystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Velocity> velocityMapper;
  Mapper<OnTrack> onTrackMapper;
  Mapper<Orientation> orientationMapper;
  GameStateManager gameStateManager;
  _$OnTrackAccelerationSystem()
      : super(Aspect.empty()
          ..allOf([Acceleration, Velocity, OnTrack, Orientation]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    velocityMapper = Mapper<Velocity>(world);
    onTrackMapper = Mapper<OnTrack>(world);
    orientationMapper = Mapper<Orientation>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$ResetAccelerationSystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  _$ResetAccelerationSystem() : super(Aspect.empty()..allOf([Acceleration]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
  }
}

abstract class _$MovementSystem extends EntityProcessingSystem {
  Mapper<Velocity> velocityMapper;
  Mapper<Position> positionMapper;
  _$MovementSystem() : super(Aspect.empty()..allOf([Velocity, Position]));
  @override
  void initialize() {
    super.initialize();
    velocityMapper = Mapper<Velocity>(world);
    positionMapper = Mapper<Position>(world);
  }
}

abstract class _$TrackSpawningSystem extends EntitySystem {
  Mapper<Track> trackMapper;
  GameStateManager gameStateManager;
  _$TrackSpawningSystem() : super(Aspect.empty()..allOf([Track]));
  @override
  void initialize() {
    super.initialize();
    trackMapper = Mapper<Track>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$CarOnTrackSystem extends EntityProcessingSystem {
  Mapper<Car> carMapper;
  Mapper<Position> positionMapper;
  Mapper<Velocity> velocityMapper;
  Mapper<Orientation> orientationMapper;
  Mapper<OnTrack> onTrackMapper;
  Mapper<Falling> fallingMapper;
  Mapper<Track> trackMapper;
  TrackSpawningSystem trackSpawningSystem;
  MagLockManager magLockManager;
  _$CarOnTrackSystem()
      : super(Aspect.empty()
          ..allOf([Car, Position, Velocity, Orientation])
          ..exclude([Falling]));
  @override
  void initialize() {
    super.initialize();
    carMapper = Mapper<Car>(world);
    positionMapper = Mapper<Position>(world);
    velocityMapper = Mapper<Velocity>(world);
    orientationMapper = Mapper<Orientation>(world);
    onTrackMapper = Mapper<OnTrack>(world);
    fallingMapper = Mapper<Falling>(world);
    trackMapper = Mapper<Track>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$TrackDespawningSystem extends EntityProcessingSystem {
  Mapper<Track> trackMapper;
  Mapper<Position> positionMapper;
  TrackSpawningSystem trackSpawningSystem;
  TagManager tagManager;
  _$TrackDespawningSystem() : super(Aspect.empty()..allOf([Track, Position]));
  @override
  void initialize() {
    super.initialize();
    trackMapper = Mapper<Track>(world);
    positionMapper = Mapper<Position>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
    tagManager = world.getManager<TagManager>();
  }
}

abstract class _$CameraMovementSystem extends VoidEntitySystem {
  Mapper<Position> positionMapper;
  Mapper<Velocity> velocityMapper;
  TagManager tagManager;
  CameraManager cameraManager;
  @override
  void initialize() {
    super.initialize();
    positionMapper = Mapper<Position>(world);
    velocityMapper = Mapper<Velocity>(world);
    tagManager = world.getManager<TagManager>();
    cameraManager = world.getManager<CameraManager>();
  }
}

abstract class _$TrackDestroyerSystem extends EntityProcessingSystem {
  Mapper<TrackDestroyer> trackDestroyerMapper;
  Mapper<Position> positionMapper;
  Mapper<Mass> massMapper;
  TrackSpawningSystem trackSpawningSystem;
  GameStateManager gameStateManager;
  _$TrackDestroyerSystem()
      : super(Aspect.empty()..allOf([TrackDestroyer, Position]));
  @override
  void initialize() {
    super.initialize();
    trackDestroyerMapper = Mapper<TrackDestroyer>(world);
    positionMapper = Mapper<Position>(world);
    massMapper = Mapper<Mass>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$ScoringSystem extends EntityProcessingSystem {
  Mapper<Controller> controllerMapper;
  Mapper<Position> positionMapper;
  Mapper<Falling> fallingMapper;
  GameStateManager gameStateManager;
  _$ScoringSystem() : super(Aspect.empty()..allOf([Controller, Position]));
  @override
  void initialize() {
    super.initialize();
    controllerMapper = Mapper<Controller>(world);
    positionMapper = Mapper<Position>(world);
    fallingMapper = Mapper<Falling>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$CarParticleSpawningSystem extends EntityProcessingSystem {
  Mapper<Car> carMapper;
  Mapper<Position> positionMapper;
  Mapper<Velocity> velocityMapper;
  Mapper<Orientation> orientationMapper;
  Mapper<OnTrack> onTrackMapper;
  MagLockManager magLockManager;
  _$CarParticleSpawningSystem()
      : super(Aspect.empty()
          ..allOf([Car, Position, Velocity, Orientation, OnTrack])
          ..exclude([Falling]));
  @override
  void initialize() {
    super.initialize();
    carMapper = Mapper<Car>(world);
    positionMapper = Mapper<Position>(world);
    velocityMapper = Mapper<Velocity>(world);
    orientationMapper = Mapper<Orientation>(world);
    onTrackMapper = Mapper<OnTrack>(world);
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$ParticleExpirationSystem extends EntityProcessingSystem {
  Mapper<Lifetime> lifetimeMapper;
  Mapper<Particle> particleMapper;
  Mapper<Color> colorMapper;
  _$ParticleExpirationSystem()
      : super(Aspect.empty()..allOf([Lifetime, Particle, Color]));
  @override
  void initialize() {
    super.initialize();
    lifetimeMapper = Mapper<Lifetime>(world);
    particleMapper = Mapper<Particle>(world);
    colorMapper = Mapper<Color>(world);
  }
}

abstract class _$TrackDestroyerAccelerationSystem
    extends EntityProcessingSystem {
  Mapper<TrackDestroyer> trackDestroyerMapper;
  Mapper<Acceleration> accelerationMapper;
  _$TrackDestroyerAccelerationSystem()
      : super(Aspect.empty()..allOf([TrackDestroyer, Acceleration]));
  @override
  void initialize() {
    super.initialize();
    trackDestroyerMapper = Mapper<TrackDestroyer>(world);
    accelerationMapper = Mapper<Acceleration>(world);
  }
}
