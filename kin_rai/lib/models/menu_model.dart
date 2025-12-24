class MenuModel {
  final int id;
  final String name;
  final int calories;
  // final double protein;
  // final double fat;
  // final double carbs;
  // final String foodType;
  final String imageUrl;

  MenuModel({
    required this.id,
    required this.name,
    required this.calories,
    // required this.protein,
    // required this.fat,
    // required this.carbs,
    // required this.foodType,
    required this.imageUrl,
  });

  // factory MenuModel.fromJson(Map<String, dynamic> json) {
  //   return MenuModel(
  //     id: int.parse(json['id']),
  //     name: json['menu_name'],
  //     calories: int.parse(json['calories']),
  //     protein: double.parse(json['protein']),
  //     fat: double.parse(json['fat']),
  //     carbs: double.parse(json['carbs']),
  //     foodType: json['food_type'],
  //     imageUrl: json['image_url'],
  //   );
  // }
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      calories: int.parse(json['calories'].toString()),
      imageUrl: json['imageUrl'],
    );
  }
}
