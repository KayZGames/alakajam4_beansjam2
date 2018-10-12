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
