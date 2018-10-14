import 'dart:async';
import 'dart:math';

import 'package:alakajam4_beansjam2/client.dart';
import 'package:alakajam4_beansjam2/src/shared/managers.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'game-menu',
  templateUrl: 'game_menu.html',
  styleUrls: ['game_menu.css'],
  directives: [
    NgIf,
  ],
)
class GameMenuComponent {
  GameService service;
  GameMenuComponent(this.service);

  void startGame() {
    service.startGame();
  }

  void startScreensaverMode() {
    service.startGame(screensaverMode: true);
  }

  bool get gameOver => service.gameOver;
  int get score => service.gameStateManager.score;
  int get bestScore => max(service.bestScore, score);
}

class GameService {
  Game _game;
  bool error = false;
  bool showPrivacyPolicy = false;
  bool showChangelog = false;
  Object errorMessage;
  StackTrace stackTrace;
  String lastName = '';
  int bestScore = 0;

  final GameStateManager gameStateManager;
  GameService(this.gameStateManager);

  bool get menuVisible =>
      gameStateManager.state == GameState.menu ||
      gameStateManager.state == GameState.gameOver;
  bool get gameOver => gameStateManager.state == GameState.gameOver;

  void startGame({bool screensaverMode = false}) {
    runZoned(() {
      bestScore = max(gameStateManager.score, bestScore);
      gameStateManager
        ..score = 0
        ..state = GameState.running
        ..screensaverMode = screensaverMode;
      _game?.destroy();
      _game = Game(gameStateManager);
      _game.start();
    }, onError: (errorMessage, stackTrace) {
      error = true;
      this.errorMessage = errorMessage;
      this.stackTrace = stackTrace;
    });
  }
}
