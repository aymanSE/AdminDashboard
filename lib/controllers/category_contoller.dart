import '../models/category_model.dart';

import 'api_helper.dart';

class CategoryController {
  String path = "category/";
  Future<List<Category>> getAll() async {
    dynamic jsonObject = await ApiHelper().get(path);
    List<Category> result = [];
    jsonObject.forEach((json) {
      result.add(Category.fromJson(json));
    });
    return result;
  }

  Future<Category> getByID(int id) async {
    dynamic jsonObject = await ApiHelper().get("$path$id");
    Category result = Category.fromJson(jsonObject);
    return result;
  }

  Future<Category> create(Category category) async {
    dynamic jsonObject = await ApiHelper().post(path, body: category.toJson());
    Category result = Category.fromJson(jsonObject);
    return result;
  }

  Future<Category> update(Category category) async {
    dynamic jsonObject = await ApiHelper().put(path, category.toJson());
    Category result = Category.fromJson(jsonObject);
    return result;
  }

  Future<void> destroy(int id) async {
    dynamic jsonObject = await ApiHelper().delete("$path$id");
    // Category result = Category.fromJson(jsonObject);
    // return result;
  }
}
