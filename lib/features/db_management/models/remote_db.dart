class RemoteDatabase {
  final String name;
  final String url;
  RemoteDatabase({required this.name, required this.url});

  Map<String, dynamic> toJson() => {"url": url, "name": name};

  factory RemoteDatabase.fromJson(Map<String, dynamic> json) =>
      RemoteDatabase(name: json["name"], url: json["url"]);

  @override
  String toString() => "RemoteDatabase(name: $name, url: $url)";
}
