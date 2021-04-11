class AccountEntity {
  final String login;
  final String avatar;
  final String location;
  final String bio;
  final String name;
  final String email;

  AccountEntity(
    this.login,
    this.avatar,
    this.location,
    this.bio,
    this.name,
    this.email,
  );

  factory AccountEntity.fromJson(Map json) {
    return AccountEntity(
      json['login'],
      json['avatar'],
      json['location'],
      json['bio'],
      json['name'],
      json['email'],
    );
  }
}
