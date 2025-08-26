import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

class FirebaseHttp {
  final String authority;

  FirebaseHttp({required this.authority});

  Future<http.Response> get({
    required String path,
    bool shallow = false,
    int? limitToFirst,
  }) async {
    final String host = Uri.parse(authority).host;
    final Uri url = Uri.https(host, "$path.json", {
      "shallow": shallow.toString(),
      if (limitToFirst != null) "limitToFirst": limitToFirst.toString(),
    });
    dev.log("FirebaseHttp GET: $url");
    final http.Response response = await http.get(url);
    dev.log("FirebaseHttp RESPONSE: ${response.body}");
    return response;
  }
}
