class FamilyMember {
  final String name;
  final String relationship;
  final String? profession;
  final String? imagePath;

  const FamilyMember({
    required this.name,
    required this.relationship,
    this.profession,
    this.imagePath,
  });
}
