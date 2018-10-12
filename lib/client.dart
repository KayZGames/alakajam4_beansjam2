library client;

import 'dart:html';
import 'package:alakajam4_beansjam2/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';

import 'src/client/systems/events.dart';
import 'src/client/systems/rendering.dart';

class Game extends GameBase {
  CanvasElement hudCanvas;
  CanvasRenderingContext2D hudCtx;
  DivElement container;

  Game() : super.noAssets('alakajam4_beansjam2', '#game', webgl: true) {
    container = querySelector('#gamecontainer');
    hudCanvas = querySelector('#hud');
    hudCtx = hudCanvas.context2D;
    _configureHud();
  }

  @override
  void createEntities() {
    final tagManager = TagManager();
    world.addManager(tagManager);
    world.addManager(WebGlViewProjectionMatrixManager(1000));
    final player = addEntity([
      Controller(),
      Position(0.0, 0.0),
      Acceleration(0.0, 0.0),
      Velocity(0.0, 0.0),
      Mass(),
    ]);

    tagManager.register(player, playerTag);
    tagManager.register(player, cameraTag);
  }

  @override
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        ControllerSystem(),
        ResetAccelerationSystem(),
        ControllerToActionSystem(),
        SimpleGravitySystem(),
        SimpleAccelerationSystem(),
        SimpleMovementSystem(),
        WebGlCanvasCleaningSystem(gl),
        PositionRenderingSystem(gl),
        CanvasCleaningSystem(hudCanvas),
        FpsRenderingSystem(hudCtx, 'white'),
      ],
      GameBase.physics: [
        // add at least one
      ]
    };
  }

  @override
  void handleResize() {
    final camera = world.getManager<CameraManager>();
    container.style
      ..width = '${camera.clientWidth}px'
      ..height = '${camera.clientHeight}px';
    resizeCanvas(hudCanvas, useClientSize: true);
    _configureHud();
    super.handleResize();
  }

  void _configureHud() {
    hudCtx
      ..textBaseline = 'top'
      ..font = '16px Verdana';
  }
}
