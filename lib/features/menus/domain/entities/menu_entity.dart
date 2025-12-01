import 'dish_entity.dart';

class MenuEntity {
  final int? id;
  final String nombre;
  final String? tipo;
  final String? descripcion;
  final double precioPorPersona;
  final double? costoPorPersona;
  final bool estaActivo;
  final List<DishEntity>? dishes;

  MenuEntity({
    this.id,
    required this.nombre,
    this.tipo,
    this.descripcion,
    required this.precioPorPersona,
    this.costoPorPersona,
    this.estaActivo = true,
    this.dishes,
  });

  double? get margen {
    if (costoPorPersona != null && costoPorPersona! > 0) {
      return ((precioPorPersona - costoPorPersona!) / costoPorPersona!) * 100;
    }
    return null;
  }
}
