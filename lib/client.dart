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
    world.getManager<CameraManager>().gameZoom = 0.1;
    final tagManager = TagManager();
    world.addManager(tagManager);
    world.addManager(WebGlViewProjectionMatrixManager(1000));
    final camera = addEntity([
      Position(0.0, 0.0),
    ]);
    final player = addEntity([
      Controller(),
      Position(0.0, 0.0),
      Acceleration(0.0, 0.0),
      Velocity(10.0, 0.0),
      Mass(),
      Orientation(0.0),
      Car(),
    ]);
//    addEntity([
//      Controller(),
//      Position(-carWidthHalf * 2 - 0.1, 0.0),
//      Acceleration(0.0, 0.0),
//      Velocity(0.0, 0.0),
//      Mass(),
//      Orientation(0.0),
//      Car(),
//    ]);
//    addEntity([
//      Controller(),
//      Position(-carWidthHalf * 4 - 0.2, 0.0),
//      Acceleration(0.0, 0.0),
//      Velocity(0.0, 0.0),
//      Mass(),
//      Orientation(0.0),
//      Car(),
//    ]);
//    addEntity([
//      Controller(),
//      Position(-carWidthHalf * 6 - 0.3, 0.0),
//      Acceleration(0.0, 0.0),
//      Velocity(0.0, 0.0),
//      Mass(),
//      Orientation(0.0),
//      Car(),
//    ]);
//    addEntity([
//      Controller(),
//      Position(-carWidthHalf * 8 - 0.4, 0.0),
//      Acceleration(0.0, 0.0),
//      Velocity(0.0, 0.0),
//      Mass(),
//      Orientation(0.0),
//      Car(),
//    ]);
    addEntity([
      Position(-20.0, 0.0),
      Velocity(10.0, 0.0),
      TrackDestroyer(),
      Orientation(0.0)
    ]);
    tagManager.register(player, playerTag);
    tagManager.register(camera, cameraTag);
  }

  @override
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        TrackSpawningSystem(),
        ControllerSystem(),
        ResetAccelerationSystem(),
        ControllerToActionSystem(),
        GravitySystem(),
        AccelerationSystem(),
        MovementSystem(),
        CarOnTrackSystem(),
        CameraMovementSystem(),
        WebGlCanvasCleaningSystem(gl),
        CarRenderingSystem(gl),
        TrackRenderingSystem(gl),
        CanvasCleaningSystem(hudCanvas),
        VelocityRenderingSystem(hudCtx),
        FpsRenderingSystem(hudCtx, 'white'),
        TrackDespawningSystem(),
        TrackDestroyerSystem(),
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
