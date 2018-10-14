import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl';

import 'package:alakajam4_beansjam2/shared.dart';
import 'package:alakajam4_beansjam2/src/shared/managers.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart' hide Velocity;

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
  List<Attrib> attributes = [Attrib('pos', 2), Attrib('aColor', 4)];

  Float32List items;
  Uint16List indices;

  CarRenderingSystem(RenderingContext gl) : super(gl);

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    final angle = orientationMapper[entity].angle;
    var itemOffset = index * 6 * 4;
    final indexOffset = index * 3 * 2;
    final vertexOffset = index * 4;
    final dist =
        sqrt(carWidthHalf * carWidthHalf + carHeightHalf * carHeightHalf);

    items[itemOffset++] = position.x + dist * cos(angle + vertexAngle + pi);
    items[itemOffset++] = position.y + dist * sin(angle + vertexAngle + pi);
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = position.x + dist * cos(angle - vertexAngle);
    items[itemOffset++] = position.y + dist * sin(angle - vertexAngle);
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = position.x + dist * cos(angle - vertexAngle + pi);
    items[itemOffset++] = position.y + dist * sin(angle - vertexAngle + pi);
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = position.x + dist * cos(angle + vertexAngle);
    items[itemOffset++] = position.y + dist * sin(angle + vertexAngle);
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;

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

    bufferElements(attributes, items, indices);
    gl.drawElements(WebGL.TRIANGLES, length * 3 * 2, WebGL.UNSIGNED_SHORT, 0);
  }

  @override
  void updateLength(int length) {
    items = Float32List(length * 6 * 4);
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
  List<Attrib> attributes = [Attrib('pos', 2), Attrib('aColor', 4)];

  Float32List items;
  Uint16List indices;

  TrackRenderingSystem(RenderingContext gl) : super(gl);

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    var itemOffset = index * 6 * 4;
    final indexOffset = index * 3 * 2;
    final vertexOffset = index * 4;
    final currentY = position.y;
    var trackDirection = trackMapper[entity].direction;
    final nextY = position.y + trackConfigs[trackDirection].yOffset;
    final alpha = isTrackMissing(trackDirection) ? 0.0 : 1.0;

    items[itemOffset++] = position.x - trackWidthHalf;
    items[itemOffset++] = currentY - trackHeightHalf;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = alpha;
    items[itemOffset++] = position.x + trackWidthHalf;
    items[itemOffset++] = nextY - trackHeightHalf;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = alpha;
    items[itemOffset++] = position.x - trackWidthHalf;
    items[itemOffset++] = currentY + trackHeightHalf;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = alpha;
    items[itemOffset++] = position.x + trackWidthHalf;
    items[itemOffset++] = nextY + trackHeightHalf;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = 1.0;
    items[itemOffset++] = alpha;

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

    bufferElements(attributes, items, indices);
    gl.drawElements(WebGL.TRIANGLES, length * 3 * 2, WebGL.UNSIGNED_SHORT, 0);
  }

  @override
  void updateLength(int length) {
    items = Float32List(length * 6 * 4);
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
      ..fillText(
          'Velocity: ${velocity.value}:${velocity.angle / pi * 180}', 5, 20)
      ..restore();
  }
}

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class ScoreRenderingSystem extends _$ScoreRenderingSystem {
  CanvasRenderingContext2D ctx;
  ScoreRenderingSystem(this.ctx);

  @override
  void processSystem() {
    final width = ctx.canvas.width;
    final scoreText = '${gameStateManager.score}';
    final scoreWidth = ctx.measureText(scoreText).width;
    ctx
      ..save()
      ..fillStyle = 'aquablue'
      ..fillText('Score:', width - max(scoreWidth + 45, 100), 5)
      ..fillText('$scoreText', width - scoreWidth - 5, 5)
      ..restore();
  }
}
