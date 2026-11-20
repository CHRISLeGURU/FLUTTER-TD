import 'package:flutter/material.dart';

import '../data/family_data.dart';
import '../models/family_member.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  static const Color copper = Color(0xFFB87333);
  static const Color sand = Color(0xFFE8DCC8);
  static const Color muted = Color(0xFF77716B);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 2 : 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MES RACINES',
                style: TextStyle(
                  color: copper,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ma famille',
                style: TextStyle(
                  color: sand,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Les personnes qui font partie de mon histoire '
                'et de mon parcours.',
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: familyMembers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 225,
                ),
                itemBuilder: (context, index) {
                  return _buildFamilyCard(familyMembers[index]);
                },
              ),
            ],
          ),
        );
      },
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
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF38312B),
            backgroundImage: member.imagePath != null
                ? AssetImage(member.imagePath!)
                : null,
            child: member.imagePath == null
                ? const Icon(
                    Icons.person,
                    color: copper,
                    size: 34,
                  )
                : null,
          ),
          const Spacer(),
          Text(
            member.relationship.toUpperCase(),
            style: const TextStyle(
              color: copper,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: sand,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (member.profession != null) ...[
            const SizedBox(height: 6),
            Text(
              member.profession!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
