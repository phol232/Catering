import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/dish_entity.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenusLoaded extends MenuState {
  final List<MenuEntity> menus;
  MenusLoaded(this.menus);
}

class DishesLoaded extends MenuState {
  final List<DishEntity> dishes;
  DishesLoaded(this.dishes);
}

class MenuOperationSuccess extends MenuState {
  final String message;
  MenuOperationSuccess(this.message);
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}
