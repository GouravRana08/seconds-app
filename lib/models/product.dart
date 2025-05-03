class Product {
  final String id;
  final String name;
  final double price;
  final double? discountedPrice; // Optional field

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
  });
}
