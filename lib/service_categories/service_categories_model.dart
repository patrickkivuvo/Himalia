

import 'dart:convert';

List<ServiceCategories> serviceCategoriesFromJson(String str) => List<ServiceCategories>.from(json.decode(str).map((x) => ServiceCategories.fromJson(x)));

String serviceCategoriesToJson(List<ServiceCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceCategories {
  ServiceCategories({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory ServiceCategories.fromJson(Map<String, dynamic> json) => ServiceCategories(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
