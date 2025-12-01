import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/dish_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';
import '../models/menu_model.dart';
import '../models/dish_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MenuEntity>> getMenus() async {
    return await remoteDataSource.getMenus();
  }

  @override
  Future<MenuEntity> getMenuById(int id) async {
    return await remoteDataSource.getMenuById(id);
  }

  @override
  Future<MenuEntity> createMenu(MenuEntity menu) async {
    final menuModel = MenuModel(
      nombre: menu.nombre,
      tipo: menu.tipo,
      descripcion: menu.descripcion,
      precioPorPersona: menu.precioPorPersona,
      costoPorPersona: menu.costoPorPersona,
      estaActivo: menu.estaActivo,
    );
    return await remoteDataSource.createMenu(menuModel);
  }

  @override
  Future<MenuEntity> updateMenu(MenuEntity menu) async {
    final menuModel = MenuModel(
      id: menu.id,
      nombre: menu.nombre,
      tipo: menu.tipo,
      descripcion: menu.descripcion,
      precioPorPersona: menu.precioPorPersona,
      costoPorPersona: menu.costoPorPersona,
      estaActivo: menu.estaActivo,
    );
    return await remoteDataSource.updateMenu(menuModel);
  }

  @override
  Future<void> deleteMenu(int id) async {
    await remoteDataSource.deleteMenu(id);
  }

  @override
  Future<void> addDishToMenu(int menuId, int dishId, int cantidad) async {
    await remoteDataSource.addDishToMenu(menuId, dishId, cantidad);
  }

  @override
  Future<void> removeDishFromMenu(int menuId, int dishId) async {
    await remoteDataSource.removeDishFromMenu(menuId, dishId);
  }

  @override
  Future<List<DishEntity>> getDishes() async {
    return await remoteDataSource.getDishes();
  }

  @override
  Future<DishEntity> createDish(DishEntity dish) async {
    final dishModel = DishModel(
      nombre: dish.nombre,
      descripcion: dish.descripcion,
      categoria: dish.categoria,
      esVegetariano: dish.esVegetariano,
      esVegano: dish.esVegano,
      esSinGluten: dish.esSinGluten,
      esSinLactosa: dish.esSinLactosa,
    );
    return await remoteDataSource.createDish(dishModel);
  }

  @override
  Future<DishEntity> updateDish(DishEntity dish) async {
    final dishModel = DishModel(
      id: dish.id,
      nombre: dish.nombre,
      descripcion: dish.descripcion,
      categoria: dish.categoria,
      esVegetariano: dish.esVegetariano,
      esVegano: dish.esVegano,
      esSinGluten: dish.esSinGluten,
      esSinLactosa: dish.esSinLactosa,
    );
    return await remoteDataSource.updateDish(dishModel);
  }

  @override
  Future<void> deleteDish(int id) async {
    await remoteDataSource.deleteDish(id);
  }
}
