class FamilyMember {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? image;
  final String? imageUrl;

  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.image,
    this.imageUrl,
  });

  String get fullName => '$nom $postnom $prenom'.trim();

  // Pour compatibilité avec d'anciens widgets si besoin
  String get name => fullName;
  String get relationship => parente;

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      nom: (json['nom'] as String? ?? '').trim(),
      postnom: (json['postnom'] as String? ?? '').trim(),
      prenom: (json['prenom'] as String? ?? '').trim(),
      lieuNaissance: (json['lieu_naissance'] as String? ?? '').trim(),
      dateNaissance: (json['date_naissance'] as String? ?? '').trim(),
      parente: (json['parente'] as String? ?? '').trim(),
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
      if (image != null) 'image': image,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  FamilyMember copyWith({
    int? id,
    String? nom,
    String? postnom,
    String? prenom,
    String? lieuNaissance,
    String? dateNaissance,
    String? parente,
    String? image,
    String? imageUrl,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      postnom: postnom ?? this.postnom,
      prenom: prenom ?? this.prenom,
      lieuNaissance: lieuNaissance ?? this.lieuNaissance,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      parente: parente ?? this.parente,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
