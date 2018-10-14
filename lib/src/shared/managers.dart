import 'package:dartemis/dartemis.dart';

class GameStateManager extends Manager {
  GameState state = GameState.menu;
  int score = 0;
  bool screensaverMode = false;
}

class MagLockManager extends Manager {
  bool magLockActive = true;

  void toggleMagLock() {
    magLockActive = !magLockActive;
  }
}

enum GameState { menu, running, gameOver }
