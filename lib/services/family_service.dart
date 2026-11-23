import '../models/family_member.dart';
import 'api_service.dart';

class FamilyService {
  // Récupérer tous les membres : GET /famille-membres
  static Future<List<FamilyMember>> getMembers() async {
    final response = await ApiService.get('famille-membres');

    if (response['data'] is List) {
      final list = response['data'] as List<dynamic>;
      return list
          .map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Récupérer un membre par son ID : GET /famille-membres/{id}
  static Future<FamilyMember> getMember(int id) async {
    final response = await ApiService.get('famille-membres/$id');

    if (response['data'] is Map<String, dynamic>) {
      return FamilyMember.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw ApiException('Membre introuvable.');
  }

  // Créer un membre :
  // - En multipart si une image est fournie : POST /famille-membres
  // - En JSON si aucune image : POST /famille-membres
  static Future<FamilyMember> createMember({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    List<int>? imageBytes,
    String? imageName,
  }) async {
    Map<String, dynamic> response;

    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    if (imageBytes != null && imageBytes.isNotEmpty && imageName != null) {
      response = await ApiService.multipartPost(
        'famille-membres',
        fields: fields,
        fileBytes: imageBytes,
        fileName: imageName,
      );
    } else {
      response = await ApiService.post('famille-membres', fields);
    }

    if (response['data'] is Map<String, dynamic>) {
      return FamilyMember.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw ApiException(
      response['message'] as String? ?? 'Erreur lors de la création du membre.',
    );
  }

  // Mettre à jour un membre :
  // - En PUT (JSON) si pas de nouvelle image (conserve l'image existante)
  // - En POST (multipart) si une nouvelle image est sélectionnée (exigé par PHP car PUT ne lit pas $_FILES)
  static Future<FamilyMember> updateMember({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    List<int>? newImageBytes,
    String? newImageName,
  }) async {
    Map<String, dynamic> response;

    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    if (newImageBytes != null && newImageBytes.isNotEmpty && newImageName != null) {
      response = await ApiService.multipartPost(
        'famille-membres/$id',
        fields: fields,
        fileBytes: newImageBytes,
        fileName: newImageName,
      );
    } else {
      response = await ApiService.put('famille-membres/$id', fields);
    }

    if (response['data'] is Map<String, dynamic>) {
      return FamilyMember.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw ApiException(
      response['message'] as String? ?? 'Erreur lors de la mise à jour.',
    );
  }

  // Supprimer un membre : DELETE /famille-membres/{id}
  static Future<void> deleteMember(int id) async {
    await ApiService.delete('famille-membres/$id');
  }
}
