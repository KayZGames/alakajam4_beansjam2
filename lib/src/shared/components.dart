import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';

class Controller extends Component {
  bool up, down, left, right;
  bool upleft, upright, downleft, downright;
  bool space;

  Controller(
      {this.up = false,
      this.down = false,
      this.left = false,
      this.right = false,
      this.upleft = false,
      this.upright = false,
      this.downleft = false,
      this.downright = false,
      this.space = false});

  void reset() {
    up = false;
    down = false;
    left = false;
    right = false;
    upleft = false;
    upright = false;
    downleft = false;
    downright = false;
    space = false;
  }
}

class Acceleration extends Component {
  double value;
  double angle;
  Acceleration(this.value, this.angle);

  void addAcceleration(double value, double angle) {
    final x = this.value * cos(this.angle) + value * cos(angle);
    final y = this.value * sin(this.angle) + value * sin(angle);
    this.angle = atan2(y, x);
    this.value = sqrt(y * y + x * x);
  }
}

class Velocity extends Component {
  double value;
  double angle;
  Velocity(this.value, this.angle);

  void addVelocity(double value, double angle) {
    final x = this.value * cos(this.angle) + value * cos(angle);
    final y = this.value * sin(this.angle) + value * sin(angle);
    this.angle = atan2(y, x);
    this.value = sqrt(y * y + x * x);
  }
}

class Car extends Component {}

class OnTrack extends Component {}

class Track extends Component {
  TrackDirection direction;
  Track(this.direction);
}

class TrackDestroyer extends Component {}

class Falling extends Component {}

class Lifetime extends Component {
  double timeLeft, timeMax;

  Lifetime(this.timeMax) : timeLeft = timeMax;
}
