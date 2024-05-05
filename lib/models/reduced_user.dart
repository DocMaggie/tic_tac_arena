class ReducedUser {

  final int id;
  final String username;

  const ReducedUser({
    required this.id,
    required this.username
  });

  factory ReducedUser.fromJson(Map<String, dynamic> json) {
    return ReducedUser(
      id: json['id'],
      username: json['username']
    );
  }

}
