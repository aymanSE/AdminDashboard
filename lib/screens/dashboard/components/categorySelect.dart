import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../controllers/category_contoller.dart';

class CategorySelector extends StatefulWidget {
  CategorySelector({Key? key}) : super(key: key);
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  void initState() {
    // TODO: implement initState
    _loadCategories();
  }

  late Future<List<Category>> _categoriesFuture;
  String? _selectedCategory;
  var _categories = <DropdownMenuItem>[];
  _loadCategories() async {
    var _categoryService = CategoryController();
    var categories = await _categoryService.getAll();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category.name),
          value: category.id,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategoryName = '';

    return Text(_categories.toString());
  }
}
