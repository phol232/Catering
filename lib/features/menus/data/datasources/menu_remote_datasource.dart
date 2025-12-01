import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/menu_model.dart';
import '../models/dish_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuModel>> getMenus();
  Future<MenuModel> getMenuById(int id);
  Future<MenuModel> createMenu(MenuModel menu);
  Future<MenuModel> updateMenu(MenuModel menu);
  Future<void> deleteMenu(int id);
  Future<void> addDishToMenu(int menuId, int dishId, int cantidad);
  Future<void> removeDishFromMenu(int menuId, int dishId);

  Future<List<DishModel>> getDishes();
  Future<DishModel> createDish(DishModel dish);
  Future<DishModel> updateDish(DishModel dish);
  Future<void> deleteDish(int id);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final SupabaseClient supabaseClient;

  MenuRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<MenuModel>> getMenus() async {
    final response = await supabaseClient
        .from('menus')
        .select('*, menu_dishes(cantidad, dish:dishes(*))')
        .order('nombre');

    return (response as List).map((json) {
      final menu = MenuModel.fromJson(json);
      if (json['menu_dishes'] != null) {
        final dishes = (json['menu_dishes'] as List)
            .map((md) => DishModel.fromJson(md['dish']))
            .toList();
        return MenuModel(
          id: menu.id,
          nombre: menu.nombre,
          tipo: menu.tipo,
          descripcion: menu.descripcion,
          precioPorPersona: menu.precioPorPersona,
          costoPorPersona: menu.costoPorPersona,
          estaActivo: menu.estaActivo,
          dishes: dishes,
        );
      }
      return menu;
    }).toList();
  }

  @override
  Future<MenuModel> getMenuById(int id) async {
    final response = await supabaseClient
        .from('menus')
        .select('*, menu_dishes(cantidad, dish:dishes(*))')
        .eq('id', id)
        .single();

    final menu = MenuModel.fromJson(response);
    if (response['menu_dishes'] != null) {
      final dishes = (response['menu_dishes'] as List)
          .map((md) => DishModel.fromJson(md['dish']))
          .toList();
      return MenuModel(
        id: menu.id,
        nombre: menu.nombre,
        tipo: menu.tipo,
        descripcion: menu.descripcion,
        precioPorPersona: menu.precioPorPersona,
        costoPorPersona: menu.costoPorPersona,
        estaActivo: menu.estaActivo,
        dishes: dishes,
      );
    }
    return menu;
  }

  @override
  Future<MenuModel> createMenu(MenuModel menu) async {
    final response = await supabaseClient
        .from('menus')
        .insert(menu.toJson())
        .select()
        .single();

    return MenuModel.fromJson(response);
  }

  @override
  Future<MenuModel> updateMenu(MenuModel menu) async {
    final response = await supabaseClient
        .from('menus')
        .update(menu.toJson())
        .eq('id', menu.id!)
        .select()
        .single();

    return MenuModel.fromJson(response);
  }

  @override
  Future<void> deleteMenu(int id) async {
    await supabaseClient.from('menus').delete().eq('id', id);
  }

  @override
  Future<void> addDishToMenu(int menuId, int dishId, int cantidad) async {
    await supabaseClient.from('menu_dishes').insert({
      'menu_id': menuId,
      'dish_id': dishId,
      'cantidad': cantidad,
    });
  }

  @override
  Future<void> removeDishFromMenu(int menuId, int dishId) async {
    await supabaseClient
        .from('menu_dishes')
        .delete()
        .eq('menu_id', menuId)
        .eq('dish_id', dishId);
  }

  @override
  Future<List<DishModel>> getDishes() async {
    final response = await supabaseClient
        .from('dishes')
        .select()
        .order('nombre');

    return (response as List).map((json) => DishModel.fromJson(json)).toList();
  }

  @override
  Future<DishModel> createDish(DishModel dish) async {
    final response = await supabaseClient
        .from('dishes')
        .insert(dish.toJson())
        .select()
        .single();

    return DishModel.fromJson(response);
  }

  @override
  Future<DishModel> updateDish(DishModel dish) async {
    final response = await supabaseClient
        .from('dishes')
        .update(dish.toJson())
        .eq('id', dish.id!)
        .select()
        .single();

    return DishModel.fromJson(response);
  }

  @override
  Future<void> deleteDish(int id) async {
    await supabaseClient.from('dishes').delete().eq('id', id);
  }
}
