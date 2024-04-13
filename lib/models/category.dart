import 'package:flutter/material.dart';

class Category {
  Category(this.title, this.color);

  String title;
  final Color color;
}

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}
