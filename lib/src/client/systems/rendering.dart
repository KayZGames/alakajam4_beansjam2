import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl';

import 'package:alakajam4_beansjam2/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';

part 'rendering.g.dart';

@Generate(
  WebGlRenderingSystem,
  allOf: [
    Car,
    Position,
    Orientation,
  ],
  manager: [
    CameraManager,
    WebGlViewProjectionMatrixManager,
  ],
)
class CarRenderingSystem extends _$CarRenderingSystem {
  List<Attrib> attributes;

  Float32List items;
  Uint16List indices;

  CarRenderingSystem(RenderingContext gl) : super(gl) {
    attributes = [Attrib('pos', 2)];
  }

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    final angle = orientationMapper[entity].angle;
    final itemOffset = index * 2 * 4;
    final indexOffset = index * 3 * 2;
    final vertexOffset = index * 4;
    final dist =
        sqrt(carWidthHalf * carWidthHalf + carHeightHalf * carHeightHalf);

    items[itemOffset] = position.x + dist * cos(angle + vertexAngle + pi);
    items[itemOffset + 1] = position.y + dist * sin(angle + vertexAngle + pi);
    items[itemOffset + 2] = position.x + dist * cos(angle - vertexAngle);
    items[itemOffset + 3] = position.y + dist * sin(angle - vertexAngle);
    items[itemOffset + 4] = position.x + dist * cos(angle - vertexAngle + pi);
    items[itemOffset + 5] = position.y + dist * sin(angle - vertexAngle + pi);
    items[itemOffset + 6] = position.x + dist * cos(angle + vertexAngle);
    items[itemOffset + 7] = position.y + dist * sin(angle + vertexAngle);

    indices[indexOffset] = vertexOffset;
    indices[indexOffset + 1] = vertexOffset + 1;
    indices[indexOffset + 2] = vertexOffset + 2;
    indices[indexOffset + 3] = vertexOffset + 1;
    indices[indexOffset + 4] = vertexOffset + 3;
    indices[indexOffset + 5] = vertexOffset + 2;
  }

  @override
  void render(int length) {
    gl.uniformMatrix4fv(
        gl.getUniformLocation(program, 'viewProjectionMatrix'),
        false,
        webGlViewProjectionMatrixManager
            .create2dViewProjectionMatrix()
            .storage);

    drawTriangles(attributes, items, indices);
  }

  @override
  void updateLength(int length) {
    items = Float32List(length * 2 * 4);
    indices = Uint16List(length * 3 * 2);
  }

  @override
  String get vShaderFile => 'PositionRenderingSystem';
  @override
  String get fShaderFile => 'PositionRenderingSystem';
}

@Generate(
  WebGlRenderingSystem,
  allOf: [
    Track,
    Position,
  ],
  manager: [
    CameraManager,
    WebGlViewProjectionMatrixManager,
  ],
  systems: [
    TrackSpawningSystem,
  ],
)
class TrackRenderingSystem extends _$TrackRenderingSystem {
  List<Attrib> attributes;

  Float32List items;
  Uint16List indices;

  TrackRenderingSystem(RenderingContext gl) : super(gl) {
    attributes = [Attrib('pos', 2)];
  }

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    final itemOffset = index * 2 * 4;
    final indexOffset = index * 3 * 2;
    final vertexOffset = index * 4;
    final lastY =
        trackSpawningSystem.yPositions[(position.x - 1.0).floor()] ?? 0.0;

    items[itemOffset] = position.x - trackWidthHalf;
    items[itemOffset + 1] = lastY - trackHeightHalf;
    items[itemOffset + 2] = position.x + trackWidthHalf;
    items[itemOffset + 3] = position.y - trackHeightHalf;
    items[itemOffset + 4] = position.x - trackWidthHalf;
    items[itemOffset + 5] = lastY + trackHeightHalf;
    items[itemOffset + 6] = position.x + trackWidthHalf;
    items[itemOffset + 7] = position.y + trackHeightHalf;

    indices[indexOffset] = vertexOffset;
    indices[indexOffset + 1] = vertexOffset + 1;
    indices[indexOffset + 2] = vertexOffset + 2;
    indices[indexOffset + 3] = vertexOffset + 1;
    indices[indexOffset + 4] = vertexOffset + 3;
    indices[indexOffset + 5] = vertexOffset + 2;
  }

  @override
  void render(int length) {
    gl.uniformMatrix4fv(
        gl.getUniformLocation(program, 'viewProjectionMatrix'),
        false,
        webGlViewProjectionMatrixManager
            .create2dViewProjectionMatrix()
            .storage);

    drawTriangles(attributes, items, indices);
  }

  @override
  void updateLength(int length) {
    items = Float32List(length * 2 * 4);
    indices = Uint16List(length * 3 * 2);
  }

  @override
  String get vShaderFile => 'PositionRenderingSystem';
  @override
  String get fShaderFile => 'PositionRenderingSystem';
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Car,
    Velocity,
  ],
)
class VelocityRenderingSystem extends _$VelocityRenderingSystem {
  CanvasRenderingContext2D ctx;
  VelocityRenderingSystem(this.ctx);
  @override
  void processEntity(Entity entity) {
    final velocity = velocityMapper[entity];
    ctx
      ..save()
      ..fillText('Velocity: ${velocity.x}:${velocity.y}', 5, 20)
      ..restore();
  }
}
