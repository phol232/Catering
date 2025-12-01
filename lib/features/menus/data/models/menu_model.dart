import '../../domain/entities/menu_entity.dart';
import 'dish_model.dart';

class MenuModel extends MenuEntity {
  MenuModel({
    super.id,
    required super.nombre,
    super.tipo,
    super.descripcion,
    required super.precioPorPersona,
    super.costoPorPersona,
    super.estaActivo,
    super.dishes,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String?,
      descripcion: json['descripcion'] as String?,
      precioPorPersona: (json['precio_por_persona'] as num).toDouble(),
      costoPorPersona: json['costo_por_persona'] != null
          ? (json['costo_por_persona'] as num).toDouble()
          : null,
      estaActivo: json['esta_activo'] as bool? ?? true,
      dishes: json['dishes'] != null
          ? (json['dishes'] as List)
                .map((dish) => DishModel.fromJson(dish))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'precio_por_persona': precioPorPersona,
      'costo_por_persona': costoPorPersona,
      'esta_activo': estaActivo,
    };
  }
}
