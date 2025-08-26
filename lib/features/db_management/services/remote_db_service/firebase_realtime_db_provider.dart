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

  Future<bool> _isNode({required String path}) async {
    final http.Response response = await _firebaseHttp.get(
      path: path,
      limitToFirst: 1,
      shallow: true,
    );
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      return body is Map;
    } else {
      throw DbHttpException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  Future<List<Leaf>> getLeafs(String path) async {
    final http.Response response = await _firebaseHttp.get(
      path: path,
      shallow: false,
    );

    if (response.statusCode == 200) {
      final Map body = jsonDecode(response.body);
      final keys = body.keys;
      final values = body.values;
      return List.generate(
        body.keys.length,
        (index) =>
            Leaf(name: keys.elementAt(index), value: values.elementAt(index)),
      );
    } else {
      throw DbHttpException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  @override
  Future<List<DbData>> loadItem({required String path}) async {
    final http.Response response = await _firebaseHttp.get(
      path: path,
      shallow: true,
    );
    if (response.statusCode == 200) {
      final Map body = jsonDecode(response.body);
      final keys = body.keys;
      final bool isNode = await _isNode(path: "$path/${body.keys.first}");
      if (isNode) {
        return List.generate(
          body.keys.length,
          (index) => Node(name: keys.elementAt(index)),
        );
      } else {
        // leaf
        return await getLeafs(path);
      }
    } else {
      throw DbHttpException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}
