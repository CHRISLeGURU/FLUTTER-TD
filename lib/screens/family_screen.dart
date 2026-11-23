import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/family_member.dart';
import '../services/api_service.dart';
import '../services/family_service.dart';
import '../widgets/family_form_dialog.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  static const Color copper = AppTheme.copper;
  static const Color sand = AppTheme.sand;
  static const Color muted = AppTheme.warmGrey;

  List<FamilyMember> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final members = await FamilyService.getMembers();
      if (!mounted) return;
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Impossible de contacter le serveur : $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openFormDialog([FamilyMember? member]) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FamilyFormDialog(member: member),
    );

    if (result == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            member != null
                ? 'Membre modifié avec succès.'
                : 'Nouveau membre ajouté avec succès.',
          ),
          backgroundColor: copper,
        ),
      );
      _loadMembers();
    }
  }

  Future<void> _confirmDelete(FamilyMember member) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF38312B)),
        ),
        title: const Text(
          'Supprimer le membre',
          style: TextStyle(
            color: sand,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer définitivement '
          '« ${member.fullName} » de la base de données ?',
          style: const TextStyle(color: muted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Annuler',
              style: TextStyle(color: muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.burntOrange,
              foregroundColor: sand,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await FamilyService.deleteMember(member.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre supprimé avec succès.'),
            backgroundColor: copper,
          ),
        );
        _loadMembers();
      } on ApiException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppTheme.burntOrange,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression : $e'),
            backgroundColor: AppTheme.burntOrange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFormDialog(),
        backgroundColor: copper,
        foregroundColor: AppTheme.obsidian,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nouveau membre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 960
              ? 3
              : (constraints.maxWidth >= 600 ? 2 : 1);

          return RefreshIndicator(
            onRefresh: _loadMembers,
            color: copper,
            backgroundColor: const Color(0xFF222222),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MES RACINES',
                            style: TextStyle(
                              color: copper,
                              fontSize: 11,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ma famille',
                            style: TextStyle(
                              color: sand,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _isLoading ? null : _loadMembers,
                        icon: const Icon(Icons.refresh, color: copper),
                        tooltip: 'Actualiser la liste',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Les personnes qui font partie de mon histoire '
                    'et de mon parcours. Données gérées en direct via l’API REST et MySQL.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Gestion des différents états
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: copper,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Chargement des membres depuis MySQL...',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.burntOrange.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 48,
                            color: AppTheme.burntOrange,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: sand,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _loadMembers,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else if (_members.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF38312B)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.family_restroom,
                            size: 64,
                            color: copper.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Aucun membre enregistré pour le moment',
                            style: TextStyle(
                              color: sand,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'La base de données MySQL est actuellement vide.\nCliquez ci-dessous pour ajouter le premier membre.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: muted,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _openFormDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Ajouter un membre'),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _members.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (context, index) {
                        return _buildFamilyCard(_members[index]);
                      },
                    ),

                  const SizedBox(height: 80), // Espace pour le FAB
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFamilyCard(FamilyMember member) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF38312B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF38312B),
                backgroundImage: member.imageUrl != null
                    ? NetworkImage(member.imageUrl!)
                    : null,
                child: member.imageUrl == null
                    ? const Icon(
                        Icons.person,
                        color: copper,
                        size: 34,
                      )
                    : null,
              ),
              const Spacer(),
              // Boutons d'édition et suppression
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: copper,
                tooltip: 'Modifier',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _openFormDialog(member),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppTheme.burntOrange,
                tooltip: 'Supprimer',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDelete(member),
              ),
            ],
          ),
          const Spacer(),
          Text(
            member.parente.toUpperCase(),
            style: const TextStyle(
              color: copper,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            member.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: sand,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 13,
                color: muted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  member.lieuNaissance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.cake_outlined,
                size: 13,
                color: muted,
              ),
              const SizedBox(width: 4),
              Text(
                member.dateNaissance,
                style: const TextStyle(
                  color: muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
