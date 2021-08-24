class Data {
  String description = "";
  Data({
    required this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      description: json['description'],
    );
  }
}
