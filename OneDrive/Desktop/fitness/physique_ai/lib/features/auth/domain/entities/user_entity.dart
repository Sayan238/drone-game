class UserEntity {
  final String id;
  final String email;
  final String name;
  final bool isLoggedIn;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.isLoggedIn = false,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    bool? isLoggedIn,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
