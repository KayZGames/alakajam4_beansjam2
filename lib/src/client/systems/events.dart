import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:alakajam4_beansjam2/src/shared/components.dart';

part 'events.g.dart';

@Generate(GenericInputHandlingSystem, allOf: [Controller])
class ControllerSystem extends _$ControllerSystem {
  @override
  void processEntity(Entity entity) {
    final c = controllerMapper[entity]..reset();
    if (left) {
      c.left = true;
    } else if (right) {
      c.right = true;
    }
  }
}
