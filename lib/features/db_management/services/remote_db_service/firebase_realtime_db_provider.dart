import 'dart:convert';

import 'package:firebase_browser/features/core/helpers/firebase_http/firebase_http.dart';
import 'package:firebase_browser/features/db_management/models/db_data.dart';
import 'package:firebase_browser/features/db_management/models/leaf.dart';
import 'package:firebase_browser/features/db_management/models/node.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_http_exception.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_provider.dart';
import "package:http/http.dart" as http;

class FirebaseRealtimeDbProvider implements DbProvider {
  final String dbUrl;
  FirebaseRealtimeDbProvider({required this.dbUrl});

  FirebaseHttp get _firebaseHttp => FirebaseHttp(authority: dbUrl);

  int _dynamicLength(dynamic object) {
    if (object is Iterable) return object.length;
    if (object is Map) return object.length;
    return 1;
  }

  Future<bool> _isLeaf({required String path}) async {
    final http.Response response = await _firebaseHttp.get(
      path: path,
      limitToFirst: 2,
      shallow: true,
    );
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body is Map) return false;
      if (_dynamicLength(body) > 1) return false;
      return true;
    } else {
      throw DbHttpException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  @override
  Future<List<DbData>> loadItem({required String path}) async {
    final bool isLeaf = await _isLeaf(path: path);

    final http.Response response = await _firebaseHttp.get(
      path: path,
      shallow: true,
    );
    if (response.statusCode == 200) {
      if (isLeaf) {
        final String leafName = path.split("/").last.split(".").first;
        final dynamic leafValue = jsonDecode(response.body);
        return [Leaf(name: leafName, value: leafValue)];
      }
      final Map body = jsonDecode(response.body);
      final keys = body.keys;
      final List<Node> output = List.generate(
        body.keys.length,
        (index) => Node(name: keys.elementAt(index)),
      );
      output.sort((a, b) => a.name.compareTo(b.name));
      return output;
    } else {
      throw DbHttpException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}
