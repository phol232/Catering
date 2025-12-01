import '../../domain/entities/dish_entity.dart';

class DishModel extends DishEntity {
  DishModel({
    super.id,
    required super.nombre,
    super.descripcion,
    super.categoria,
    super.esVegetariano,
    super.esVegano,
    super.esSinGluten,
    super.esSinLactosa,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      categoria: json['categoria'] as String?,
      esVegetariano: json['es_vegetariano'] as bool? ?? false,
      esVegano: json['es_vegano'] as bool? ?? false,
      esSinGluten: json['es_sin_gluten'] as bool? ?? false,
      esSinLactosa: json['es_sin_lactosa'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'es_vegetariano': esVegetariano,
      'es_vegano': esVegano,
      'es_sin_gluten': esSinGluten,
      'es_sin_lactosa': esSinLactosa,
    };
  }
}
