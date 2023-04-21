import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final String? color;

  const CategoryModel({
    this.id,
    required this.name,
    this.description,
    this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CategoryModelMapping.idKey],
      name: json[CategoryModelMapping.nameKey],
      description: json[CategoryModelMapping.descriptionKey] ?? "",
      color: json[CategoryModelMapping.colorKey] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CategoryModelMapping.idKey: id,
      CategoryModelMapping.nameKey: name,
      CategoryModelMapping.descriptionKey: description,
      CategoryModelMapping.colorKey: color,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  static const empty = CategoryModel(id: '', name: '');
  static const none = CategoryModel(id: '', name: 'none');
  bool get isEmpty => this == CategoryModel.empty;
  bool get isNotEmpty => this != CategoryModel.empty;

  @override
  List<Object?> get props => [id, name, description, color];
}

class CategoryModelMapping {
  static const collectionName = 'Categories';
  static const idKey = 'id';
  static const nameKey = 'name';
  static const descriptionKey = 'description';
  static const colorKey = 'color';
}
