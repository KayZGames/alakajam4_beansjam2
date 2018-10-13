// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$ControllerToActionSystem extends EntityProcessingSystem {
  Mapper<Controller> controllerMapper;
  Mapper<Acceleration> accelerationMapper;
  _$ControllerToActionSystem()
      : super(Aspect.empty()..allOf([Controller, Acceleration]));
  @override
  void initialize() {
    super.initialize();
    controllerMapper = Mapper<Controller>(world);
    accelerationMapper = Mapper<Acceleration>(world);
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
