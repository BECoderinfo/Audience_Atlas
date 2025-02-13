class VideoModal {
  final String id;
  final Publisher publisher;
  final String title;
  final String thumbnail;
  final String video;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  VideoModal({
    required this.id,
    required this.publisher,
    required this.title,
    required this.thumbnail,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory VideoModal.fromJson(Map<String, dynamic> json) => VideoModal(
        id: json["_id"],
        publisher: Publisher.fromJson(json["publisher"]),
        title: json["title"],
        thumbnail: json["thumbnail"],
        video: json["video"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "publisher": publisher.toJson(),
        "title": title,
        "thumbnail": thumbnail,
        "video": video,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Publisher {
  final String id;
  final String image;
  final String name;
  final int subscribers;
  final int totalVideos;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Publisher({
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

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
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
