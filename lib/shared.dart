library shared;

import 'dart:math';

export 'package:gamedev_helpers/gamedev_helpers_shared.dart'
    hide Acceleration, ResetAccelerationSystem;

export 'src/shared/components.dart';
export 'src/shared/systems/logic.dart';

const double carWidthHalf = 1.0;
const double carHeight = 1.0;
const double carHeightHalf = carHeight / 2;
final double vertexAngle = atan2(carHeightHalf, carWidthHalf);

const double trackWidth = 1.0;
const double trackWidthHalf = 0.5;
const double trackHeightHalf = 0.1;
