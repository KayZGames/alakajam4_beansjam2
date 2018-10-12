import 'package:alakajam4_beansjam2/shared.dart';
import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:alakajam4_beansjam2/src/shared/components.dart';

part 'logic.g.dart';

@Generate(EntityProcessingSystem, allOf: const [Controller, Acceleration])
class ControllerToActionSystem extends _$ControllerToActionSystem {
  final _acc = 50.0;
  final _sqrttwo = 1.4142;

  @override
  void processEntity(Entity entity) {
    final controller = controllerMapper[entity];
    final acceleration = accelerationMapper[entity];
    if (controller.up) {
      acceleration.y += _acc * world.delta;
    } else if (controller.down) {
      acceleration.y -= _acc * world.delta;
    } else if (controller.left) {
      acceleration.x -= _acc * world.delta;
    } else if (controller.right) {
      acceleration.x += _acc * world.delta;
    } else if (controller.upleft) {
      acceleration.y += _acc * world.delta / _sqrttwo;
      acceleration.x -= _acc * world.delta / _sqrttwo;
    } else if (controller.upright) {
      acceleration.y += _acc * world.delta / _sqrttwo;
      acceleration.x += _acc * world.delta / _sqrttwo;
    } else if (controller.downleft) {
      acceleration.y -= _acc * world.delta / _sqrttwo;
      acceleration.x -= _acc * world.delta / _sqrttwo;
    } else if (controller.downright) {
      acceleration.y -= _acc * world.delta / _sqrttwo;
      acceleration.x += _acc * world.delta / _sqrttwo;
    }
  }
}

@Generate(
  EntitySystem,
  allOf: [
    Track,
  ],
)
class TrackSpawningSystem extends _$TrackSpawningSystem {
  double lastX = 0.0;
  double lastY = -carHeightHalf - trackHeightHalf;
  @override
  bool checkProcessing() => true;

  @override
  void processEntities(Iterable<Entity> entities) {
    for (var index = entities.length; index < 50; index++) {
      world.createAndAddEntity(
          [Position(lastX.toDouble(), lastY.toDouble()), Track()]);
      lastX += trackWidthHalf * 2;
    }
  }
}
