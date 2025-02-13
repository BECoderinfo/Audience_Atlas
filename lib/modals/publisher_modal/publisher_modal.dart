class PublisherModal {
  final String id;
  final String image;
  final String name;
  final int subscribers;
  final int totalVideos;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  PublisherModal({
    required this.id,
    required this.image,
    required this.name,
    required this.subscribers,
    required this.totalVideos,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PublisherModal.fromJson(Map<String, dynamic> json) => PublisherModal(
        id: json["_id"],
        image: json["image"] ??
            'https://avatar.iran.liara.run/public/boy?username=Ash',
        name: json["name"] ?? 'Atlas publisher',
        subscribers: json["subscribers"],
        totalVideos: json["totalVideos"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "name": name,
        "subscribers": subscribers,
        "totalVideos": totalVideos,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
