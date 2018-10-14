import 'package:dartemis/dartemis.dart';

class GameStateManager extends Manager {
  GameState state = GameState.running;
  int score = 0;
}

class MagLockManager extends Manager {
  bool magLockActive = true;

  void toggleMagLock() {
    magLockActive = !magLockActive;
  }
}

enum GameState { menu, running, gameOver }
