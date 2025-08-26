import 'package:firebase_browser/features/db_management/constants/db_constants.dart';
import 'package:firebase_browser/features/db_management/models/db_data.dart';

class Node extends DbData {
  Node({required super.name});

  factory Node.home() => Node(name: DbConstants.home);

  @override
  String toString() => "Node($name)";
}
