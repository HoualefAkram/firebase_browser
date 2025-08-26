import 'package:firebase_browser/features/db_management/models/db_data.dart';

class Leaf extends DbData {
  Leaf({required super.name, required super.value});

  @override
  String toString() => "Leaf($name: $value)";
}
