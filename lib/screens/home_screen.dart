import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color copper = Color(0xFFB87333);
  static const Color sand = Color(0xFFE8DCC8);
  static const Color muted = Color(0xFF77716B);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),

          _buildSectionTitle('À PROPOS'),
          const Text(
            'Passionné par le développement logiciel et les '
            'technologies émergentes, je m’intéresse particulièrement '
            'au développement web et mobile, à l’intelligence '
            'artificielle et à la blockchain.',
            style: TextStyle(
              color: sand,
              fontSize: 14,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('FORMATION'),
          _buildTimelineItem(
            'Génie logiciel',
            'ISIG Goma',
            '2024 – 2026 • L4',
          ),
          _buildTimelineItem(
            'Études secondaires',
            'Collège Mwanga',
            '2017 – 2023',
          ),
          _buildTimelineItem(
            'Études primaires',
            'Complexe scolaire LE GAI SAVOIR',
            null,
          ),
          _buildTimelineItem(
            'Photographie et bureautique',
            'Legend Media',
            'Formation • 2020',
          ),
          _buildTimelineItem(
            'Anglais',
            'BTC Training Center',
            'Formation • 2020',
          ),
          _buildTimelineItem(
            'Web3 et fondamentaux du Bitcoin',
            'Bridge Sats',
            'Formation • 2025',
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('EXPÉRIENCE'),
          _buildExperienceCard(
            'Designer & monteur vidéo',
            'LEGEND STUDIO',
            '2020 – 2021',
            Icons.movie_creation_outlined,
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('PROJETS TECHNIQUES'),
          _buildProjectCard(
            'MultiChainExplorer',
            'Explorateur multichaîne permettant de consulter '
                'des informations issues de plusieurs réseaux blockchain.',
            'React • TypeScript • Vite',
          ),
          _buildProjectCard(
            'Kenda',
            'Solution de gestion des infractions routières '
                'avec une approche basée sur la blockchain Cardano.',
            'Next.js • Supabase • Cardano • MeshJS',
          ),
          _buildProjectCard(
            'MalobaBridge / LinguaVox',
            'Projet de traduction vocale et de valorisation '
                'des langues africaines.',
            'React • Supabase • IA • Speech Technologies',
          ),
          _buildProjectCard(
            'Bitcoin Wallet Lab',
            'Laboratoire expérimental autour des portefeuilles '
                'Bitcoin et des interactions avec un bot Telegram.',
            'Bitcoin Core • Node.js • Telegram Bot',
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('COMPÉTENCES TECHNIQUES'),
          _buildSkillGroup(
            'Développement',
            ['JavaScript', 'TypeScript', 'React', 'Node.js',
              'React Native', 'Express'],
          ),
          _buildSkillGroup(
            'Bases de données',
            ['PostgreSQL', 'Supabase'],
          ),
          _buildSkillGroup(
            'Blockchain & Web3',
            ['Bitcoin', 'Cardano', 'Sui', 'Smart Contracts'],
          ),
          _buildSkillGroup(
            'Création numérique',
            ['Photographie', 'Montage vidéo', 'Bureautique'],
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('LANGUES'),
          _buildLanguage('Français', 'Langue de communication'),
          _buildLanguage('Anglais', 'Intermédiaire'),

          const SizedBox(height: 32),

          _buildSectionTitle('CENTRES D’INTÉRÊT'),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              'Intelligence artificielle',
              'Blockchain & Web3',
              'Développement logiciel',
              'Innovation technologique',
              'Photographie',
              'Création audiovisuelle',
            ].map((item) => _interestChip(item)).toList(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF38312B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFF38312B),
            backgroundImage: AssetImage('assets/images/theguru.png'),
          ),
          const SizedBox(height: 24),
          const Text(
            'MON PROFIL',
            style: TextStyle(
              color: copper,
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'MUMBERE SALUMU\nCHRISPIN',
            style: TextStyle(
              color: sand,
              fontSize: 27,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'SOFTWARE ENGINEER',
            style: TextStyle(
              color: copper,
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 48,
            height: 3,
            color: copper,
          ),
          const SizedBox(height: 18),
          const Text(
            'Développement logiciel • Web3 • Intelligence artificielle',
            style: TextStyle(
              color: muted,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: copper,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: sand,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String institution,
    String? period,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            color: copper,
            size: 10,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: sand,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  institution,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                  ),
                ),
                if (period != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    period,
                    style: const TextStyle(
                      color: copper,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
    String title,
    String company,
    String period,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: copper, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            color: sand,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '$company • $period',
            style: const TextStyle(color: muted),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    String name,
    String description,
    String technologies,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: copper,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: sand,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              technologies,
              style: const TextStyle(
                color: muted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillGroup(String title, List<String> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: copper,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return _interestChip(skill);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguage(String language, String level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
            style: const TextStyle(color: sand),
          ),
          Text(
            level,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2521),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF51402F),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: sand,
          fontSize: 11,
        ),
      ),
    );
  }
}
