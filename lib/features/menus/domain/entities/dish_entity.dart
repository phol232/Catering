class DishEntity {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String? categoria;
  final bool esVegetariano;
  final bool esVegano;
  final bool esSinGluten;
  final bool esSinLactosa;

  DishEntity({
    this.id,
    required this.nombre,
    this.descripcion,
    this.categoria,
    this.esVegetariano = false,
    this.esVegano = false,
    this.esSinGluten = false,
    this.esSinLactosa = false,
  });
}
