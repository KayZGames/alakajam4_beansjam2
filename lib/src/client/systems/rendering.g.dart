// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$CarRenderingSystem extends WebGlRenderingSystem {
  Mapper<Car> carMapper;
  Mapper<Position> positionMapper;
  Mapper<Orientation> orientationMapper;
  CameraManager cameraManager;
  WebGlViewProjectionMatrixManager webGlViewProjectionMatrixManager;
  _$CarRenderingSystem(RenderingContext gl)
      : super(gl, Aspect.empty()..allOf([Car, Position, Orientation]));
  @override
  void initialize() {
    super.initialize();
    carMapper = Mapper<Car>(world);
    positionMapper = Mapper<Position>(world);
    orientationMapper = Mapper<Orientation>(world);
    cameraManager = world.getManager<CameraManager>();
    webGlViewProjectionMatrixManager =
        world.getManager<WebGlViewProjectionMatrixManager>();
  }
}

abstract class _$TrackRenderingSystem extends WebGlRenderingSystem {
  Mapper<Track> trackMapper;
  Mapper<Position> positionMapper;
  TrackSpawningSystem trackSpawningSystem;
  CameraManager cameraManager;
  WebGlViewProjectionMatrixManager webGlViewProjectionMatrixManager;
  MagLockManager magLockManager;
  _$TrackRenderingSystem(RenderingContext gl)
      : super(gl, Aspect.empty()..allOf([Track, Position]));
  @override
  void initialize() {
    super.initialize();
    trackMapper = Mapper<Track>(world);
    positionMapper = Mapper<Position>(world);
    trackSpawningSystem = world.getSystem<TrackSpawningSystem>();
    cameraManager = world.getManager<CameraManager>();
    webGlViewProjectionMatrixManager =
        world.getManager<WebGlViewProjectionMatrixManager>();
    magLockManager = world.getManager<MagLockManager>();
  }
}

abstract class _$VelocityRenderingSystem extends EntityProcessingSystem {
  Mapper<Car> carMapper;
  Mapper<Velocity> velocityMapper;
  _$VelocityRenderingSystem() : super(Aspect.empty()..allOf([Car, Velocity]));
  @override
  void initialize() {
    super.initialize();
    carMapper = Mapper<Car>(world);
    velocityMapper = Mapper<Velocity>(world);
  }
}

abstract class _$ScoreRenderingSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager<GameStateManager>();
  }
}
