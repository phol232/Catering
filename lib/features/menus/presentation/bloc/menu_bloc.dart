import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuInitial()) {
    on<LoadMenusEvent>(_onLoadMenus);
    on<CreateMenuEvent>(_onCreateMenu);
    on<UpdateMenuEvent>(_onUpdateMenu);
    on<DeleteMenuEvent>(_onDeleteMenu);
    on<AddDishToMenuEvent>(_onAddDishToMenu);
    on<RemoveDishFromMenuEvent>(_onRemoveDishFromMenu);
    on<LoadDishesEvent>(_onLoadDishes);
    on<CreateDishEvent>(_onCreateDish);
    on<UpdateDishEvent>(_onUpdateDish);
    on<DeleteDishEvent>(_onDeleteDish);
  }

  Future<void> _onLoadMenus(
    LoadMenusEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final menus = await menuRepository.getMenus();
      emit(MenusLoaded(menus));
    } catch (e) {
      emit(MenuError('Error al cargar menús: ${e.toString()}'));
    }
  }

  Future<void> _onCreateMenu(
    CreateMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.createMenu(event.menu);
      emit(MenuOperationSuccess('Menú creado exitosamente'));
      add(LoadMenusEvent());
    } catch (e) {
      emit(MenuError('Error al crear menú: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMenu(
    UpdateMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.updateMenu(event.menu);
      emit(MenuOperationSuccess('Menú actualizado exitosamente'));
      add(LoadMenusEvent());
    } catch (e) {
      emit(MenuError('Error al actualizar menú: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMenu(
    DeleteMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.deleteMenu(event.menuId);
      emit(MenuOperationSuccess('Menú eliminado exitosamente'));
      add(LoadMenusEvent());
    } catch (e) {
      emit(MenuError('Error al eliminar menú: ${e.toString()}'));
    }
  }

  Future<void> _onAddDishToMenu(
    AddDishToMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      await menuRepository.addDishToMenu(
        event.menuId,
        event.dishId,
        event.cantidad,
      );
      emit(MenuOperationSuccess('Plato agregado al menú'));
      add(LoadMenusEvent());
    } catch (e) {
      emit(MenuError('Error al agregar plato: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveDishFromMenu(
    RemoveDishFromMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      await menuRepository.removeDishFromMenu(event.menuId, event.dishId);
      emit(MenuOperationSuccess('Plato eliminado del menú'));
      add(LoadMenusEvent());
    } catch (e) {
      emit(MenuError('Error al eliminar plato: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDishes(
    LoadDishesEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final dishes = await menuRepository.getDishes();
      emit(DishesLoaded(dishes));
    } catch (e) {
      emit(MenuError('Error al cargar platos: ${e.toString()}'));
    }
  }

  Future<void> _onCreateDish(
    CreateDishEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.createDish(event.dish);
      emit(MenuOperationSuccess('Plato creado exitosamente'));
      add(LoadDishesEvent());
    } catch (e) {
      emit(MenuError('Error al crear plato: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDish(
    UpdateDishEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.updateDish(event.dish);
      emit(MenuOperationSuccess('Plato actualizado exitosamente'));
      add(LoadDishesEvent());
    } catch (e) {
      emit(MenuError('Error al actualizar plato: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteDish(
    DeleteDishEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      await menuRepository.deleteDish(event.dishId);
      emit(MenuOperationSuccess('Plato eliminado exitosamente'));
      add(LoadDishesEvent());
    } catch (e) {
      emit(MenuError('Error al eliminar plato: ${e.toString()}'));
    }
  }
}
