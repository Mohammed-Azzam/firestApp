class RoleCategoryModel {
  late final List<String> roles;
  late final List<int> categoriesNumbers;
  late final List<String> categoriesNames;
  late final Map<String, int> roleCategoryMap;

  RoleCategoryModel({
    required this.roles,
    required this.categoriesNumbers,
    required this.categoriesNames,
    required this.roleCategoryMap,
  });

  RoleCategoryModel.fromJson(json) {
    this.roles = json['roles'];
    this.categoriesNumbers = json['categoriesNumbers'];
    this.categoriesNames = json['categoriesNames'];
    this.roleCategoryMap = json['roleCategoryMap'];
  }

  Map<String, dynamic> toMap() {
    return {
      "roles": roles,
      "categoriesNumbers": categoriesNumbers,
      "categoriesNames": categoriesNames,
      "roleCategoryMap": roleCategoryMap
    };
  }
}
