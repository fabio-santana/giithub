import '../../data/http/http.dart';

import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String login;
  final String avatar;
  final String location;
  final String bio;
  final String name;
  final String email;

  RemoteAccountModel(
    this.login,
    this.avatar,
    this.location,
    this.bio,
    this.name,
    this.email,
  );

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('login')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(
      json['login'],
      json['avatar'],
      json['location'],
      json['bio'],
      json['name'],
      json['email'],
    );
  }
  AccountEntity toEntity() => AccountEntity(
        login,
        avatar,
        location,
        bio,
        name,
        email,
      );
}
