class UserAccount {
  final int id;
  final String email;
  final String? createdAt;

  const UserAccount({
    required this.id,
    required this.email,
    this.createdAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt,
    };
  }
}
