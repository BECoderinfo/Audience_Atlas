class PublisherModal {
  final String id;
  final String email;
  final String password;
  final int subscribers;
  final int totalVideos;
  final String role;
  final List<String> userIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String image;
  final String name;

  PublisherModal({
    required this.id,
    required this.email,
    required this.password,
    required this.subscribers,
    required this.totalVideos,
    required this.role,
    required this.userIds,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.image,
    required this.name,
  });

  factory PublisherModal.fromJson(Map<String, dynamic> json) => PublisherModal(
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        subscribers: json["subscribers"],
        totalVideos: json["totalVideos"],
        role: json["role"],
        userIds: List<String>.from(json["userIds"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "password": password,
        "subscribers": subscribers,
        "totalVideos": totalVideos,
        "role": role,
        "userIds": List<dynamic>.from(userIds.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "image": image,
        "name": name,
      };
}
