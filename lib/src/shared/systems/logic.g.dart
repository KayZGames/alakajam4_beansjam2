// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$ControllerToActionSystem extends EntityProcessingSystem {
  Mapper<Controller> controllerMapper;
  Mapper<Acceleration> accelerationMapper;
  CarOnTrackSystem carOnTrackSystem;
  _$ControllerToActionSystem()
      : super(Aspect.empty()..allOf([Controller, Acceleration]));
  @override
  void initialize() {
    super.initialize();
    controllerMapper = Mapper<Controller>(world);
    accelerationMapper = Mapper<Acceleration>(world);
    carOnTrackSystem = world.getSystem<CarOnTrackSystem>();
  }
}

abstract class _$GravitySystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Orientation> orientationMapper;
  Mapper<Mass> massMapper;
  _$GravitySystem()
      : super(Aspect.empty()..allOf([Acceleration, Orientation, Mass]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    orientationMapper = Mapper<Orientation>(world);
    massMapper = Mapper<Mass>(world);
  }
}

abstract class _$AccelerationSystem extends EntityProcessingSystem {
  Mapper<Acceleration> accelerationMapper;
  Mapper<Velocity> velocityMapper;
  _$AccelerationSystem()
      : super(Aspect.empty()..allOf([Acceleration, Velocity]));
  @override
  void initialize() {
    super.initialize();
    accelerationMapper = Mapper<Acceleration>(world);
    velocityMapper = Mapper<Velocity>(world);
  }
}

abstract class _$MovementSystem extends EntityProcessingSystem {
  Mapper<Velocity> velocityMapper;
  Mapper<Position> positionMapper;
  Mapper<Orientation> orientationMapper;
  _$MovementSystem()
      : super(Aspect.empty()..allOf([Velocity, Position, Orientation]));
  @override
  void initialize() {
    super.initialize();
    velocityMapper = Mapper<Velocity>(world);
    positionMapper = Mapper<Position>(world);
    orientationMapper = Mapper<Orientation>(world);
  }
}

abstract class _$TrackSpawningSystem extends EntitySystem {
  Mapper<Track> trackMapper;
  _$TrackSpawningSystem() : super(Aspect.empty()..allOf([Track]));
  @override
  void initialize() {
    super.initialize();
    trackMapper = Mapper<Track>(world);
  }
}

abstract class _$CarOnTrackSystem extends EntityProcessingSystem {
  Mapper<Car> carMapper;
  Mapper<Position> positionMapper;
  Mapper<Velocity> velocityMapper;
  Mapper<Orientation> orientationMapper;
  TrackSpawningSystem trackSpawningSystem;
  _$CarOnTrackSystem()
      : super(Aspect.empty()..allOf([Car, Position, Velocity, Orientation]));
  @override
  void initialize() {
    super.initialize();
    carMapper = Mapper<Car>(world);
    positionMapper = Mapper<Position>(world);
    velocityMapper = Mapper<Velocity>(world);
    orientationMapper = Mapper<Orientation>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
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
  TrackSpawningSystem trackSpawningSystem;
  _$TrackDestroyerSystem()
      : super(Aspect.empty()..allOf([TrackDestroyer, Position]));
  @override
  void initialize() {
    super.initialize();
    trackDestroyerMapper = Mapper<TrackDestroyer>(world);
    positionMapper = Mapper<Position>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
  }
}
