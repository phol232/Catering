import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/dish_entity.dart';

abstract class MenuEvent {}

class LoadMenusEvent extends MenuEvent {}

class CreateMenuEvent extends MenuEvent {
  final MenuEntity menu;
  CreateMenuEvent(this.menu);
}

class UpdateMenuEvent extends MenuEvent {
  final MenuEntity menu;
  UpdateMenuEvent(this.menu);
}

class DeleteMenuEvent extends MenuEvent {
  final int menuId;
  DeleteMenuEvent(this.menuId);
}

class AddDishToMenuEvent extends MenuEvent {
  final int menuId;
  final int dishId;
  final int cantidad;
  AddDishToMenuEvent(this.menuId, this.dishId, this.cantidad);
}

class RemoveDishFromMenuEvent extends MenuEvent {
  final int menuId;
  final int dishId;
  RemoveDishFromMenuEvent(this.menuId, this.dishId);
}

class LoadDishesEvent extends MenuEvent {}

class CreateDishEvent extends MenuEvent {
  final DishEntity dish;
  CreateDishEvent(this.dish);
}

class UpdateDishEvent extends MenuEvent {
  final DishEntity dish;
  UpdateDishEvent(this.dish);
}

class DeleteDishEvent extends MenuEvent {
  final int dishId;
  DeleteDishEvent(this.dishId);
}
