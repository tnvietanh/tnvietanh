class UserModel {
  String id;

  String name;
  String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.profileImage,
  });
  copyWith({
    String? id,
    String? name,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'profileImage': profileImage};
  }
}
