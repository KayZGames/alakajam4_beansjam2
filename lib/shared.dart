library shared;

import 'dart:math';

export 'package:gamedev_helpers/gamedev_helpers_shared.dart';

export 'src/shared/components.dart';
export 'src/shared/systems/logic.dart';

const double carWidthHalf = 1.0;
const double carHeightHalf = 0.5;
final double vertexAngle = atan2(carHeightHalf, carWidthHalf);

const double trackWidthHalf = 1.0;
const double trackHeightHalf = 0.1;