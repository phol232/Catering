import '../entities/menu_entity.dart';
import '../entities/dish_entity.dart';

abstract class MenuRepository {
  Future<List<MenuEntity>> getMenus();
  Future<MenuEntity> getMenuById(int id);
  Future<MenuEntity> createMenu(MenuEntity menu);
  Future<MenuEntity> updateMenu(MenuEntity menu);
  Future<void> deleteMenu(int id);
  Future<void> addDishToMenu(int menuId, int dishId, int cantidad);
  Future<void> removeDishFromMenu(int menuId, int dishId);

  Future<List<DishEntity>> getDishes();
  Future<DishEntity> createDish(DishEntity dish);
  Future<DishEntity> updateDish(DishEntity dish);
  Future<void> deleteDish(int id);
}
