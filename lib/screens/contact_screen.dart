import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const Color copper = Color(0xFFB87333);
  static const Color sand = Color(0xFFE8DCC8);
  static const Color muted = Color(0xFF77716B);

  Future<void> _openLink(String value) async {
    final uri = Uri.parse(value);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Impossible d’ouvrir le lien : $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESTONS EN CONTACT',
            style: TextStyle(
              color: copper,
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Me contacter',
            style: TextStyle(
              color: sand,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Pour toute collaboration, opportunité professionnelle '
            'ou échange autour des technologies, n’hésitez pas '
            'à me contacter.',
            style: TextStyle(
              color: muted,
              fontSize: 14,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 32),

          _contactCard(
            icon: Icons.phone_outlined,
            title: 'Téléphone',
            value: '+243970514412',
          ),

          _contactCard(
            icon: Icons.email_outlined,
            title: 'Adresse e-mail',
            value: 'salumuchris21@gmail.com',
       ),

          _contactCard(
            icon: Icons.location_on_outlined,
            title: 'Localisation',
            value: 'Goma, Nord-Kivu, RDC',
          ),

          const SizedBox(height: 32),

          const Text(
            'MES PROFILS EN LIGNE',
            style: TextStyle(
              color: sand,
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          _socialCard(
            icon: Icons.code,
            title: 'GitHub',
            subtitle: 'Mes projets et contributions',
            onTap: () => _openLink(
              'https://github.com/CHRISLeGURU',
            ),
          ),

          _socialCard(
            icon: Icons.language,
            title: 'Portfolio web',
            subtitle: 'Mon univers professionnel',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('christheguru.vercel.app '),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2521),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF51402F),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.handshake_outlined,
                  color: copper,
                  size: 32,
                ),
                SizedBox(height: 14),
                Text(
                  'Construisons quelque chose ensemble.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: sand,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Merci de votre visite !',
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: copper, size: 27),
        title: Text(
          title,
          style: const TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            value,
            style: const TextStyle(
              color: sand,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: copper, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: sand,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
        trailing: const Icon(
          Icons.open_in_new,
          color: copper,
          size: 18,
        ),
      ),
    );
  }
}
