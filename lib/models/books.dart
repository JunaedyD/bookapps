class Books {
  final String id;
  String name;
  String description;
  String createdbyid;
  String created;

  Books({this.id, this.name, this.description, this.createdbyid, this.created});

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        createdbyid: json['createdbyid'],
        created: json['created']);
  }
}