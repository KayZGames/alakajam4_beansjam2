library client;

import 'dart:html';
import 'package:alakajam4_beansjam2/shared.dart';
import 'package:alakajam4_beansjam2/src/shared/managers.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart'
    hide
        Acceleration,
        Velocity,
        ResetAccelerationSystem,
        WebGlCanvasCleaningSystem;

import 'src/client/systems/events.dart';
import 'src/client/systems/rendering.dart';

class Game extends GameBase {
  CanvasElement hudCanvas;
  CanvasRenderingContext2D hudCtx;
  DivElement container;
  GameStateManager gameStateManager;

  Game(this.gameStateManager)
      : super.noAssets('alakajam4_beansjam2', '#game', webgl: true) {
    container = querySelector('#gamecontainer');
    hudCanvas = querySelector('#hud');
    hudCtx = hudCanvas.context2D;
    _configureHud();
  }

  @override
  void createEntities() {
    final tagManager = TagManager();
    world.getManager<CameraManager>().gameZoom = 0.1;
    world
      ..addManager(tagManager)
      ..addManager(WebGlViewProjectionMatrixManager(1000))
      ..addManager(MagLockManager())
      ..addManager(gameStateManager);
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
      OnTrack(),
    ]);
    addEntity([
      Position(-20.0, 0.0),
      Velocity(10.0, 0.0),
      TrackDestroyer(),
      Orientation(0.0)
    ]);
    if (gameStateManager.screensaverMode) {
      for (int i = 0; i < 5; i++) {
        addEntity([
          Controller(),
          Position(-carWidthHalf * 2 * i - 0.1 * i, 0.0),
          Acceleration(0.0, 0.0),
          Velocity(10.0, 0.0),
          Mass(),
          Orientation(0.0),
          Car(),
          OnTrack(),
        ]);
      }
    }
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
        MagneticForceSystem(),
        GravitySystem(),
        OnTrackGravitySystem(),
        AccelerationSystem(),
        OnTrackAccelerationSystem(),
        MovementSystem(),
        CarOnTrackSystem(),
        CameraMovementSystem(),
        ScoringSystem(),
        WebGlCanvasCleaningSystem(gl),
        TrackRenderingSystem(gl),
        CarRenderingSystem(gl),
        ParticleRenderingSystem(gl),
        CanvasCleaningSystem(hudCanvas),
        ScoreRenderingSystem(hudCtx),
//        VelocityRenderingSystem(hudCtx),
//        FpsRenderingSystem(hudCtx, 'white'),
        TrackDespawningSystem(),
        TrackDestroyerSystem(),
        CarParticleSpawningSystem(),
        ParticleExpirationSystem(),
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

  void destroy() {
    world
      ..deleteAllEntities()
      ..destroy();
  }
}
