import 'package:alakajam4_beansjam2/src/ng2/game_menu/game_menu.dart';
import 'package:alakajam4_beansjam2/src/shared/managers.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'alakajam4-beansjam2',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [
    GameMenuComponent,
    NgIf,
  ],
  providers: [
    GameService,
    GameStateManager,
  ],
)
class AppComponent {
  GameService service;
  AppComponent(this.service);

  bool get menuVisible => service.menuVisible;
}
