class CvData {
  static const String fullName = 'MUMBERE SALUMU CHRISPIN';

  static const String professionalTitle = 'Software Engineer';

  static const String profile =
      'Passionné par le développement logiciel et les technologies '
      'émergentes, je m’intéresse particulièrement au développement '
      'web et mobile, à l’intelligence artificielle et à la blockchain.';

  static const List<Map<String, String>> education = [
    {
      'title': 'Génie logiciel',
      'institution': 'ISIG Goma',
      'period': '2024 – 2026 • L4',
    },
    {
      'title': 'Études secondaires',
      'institution': 'Collège Mwanga',
      'period': '2017 – 2023',
    },
    {
      'title': 'Études primaires',
      'institution': 'Complexe scolaire LE GAI SAVOIR',
      'period': 'Dates à compléter',
    },
    {
      'title': 'Photographie et bureautique',
      'institution': 'Legend Media',
      'period': '2020',
    },
    {
      'title': 'Formation en anglais',
      'institution': 'BTC Training Center',
      'period': '2020',
    },
    {
      'title': 'Web3 et fondamentaux du Bitcoin',
      'institution': 'Bridge Sats',
      'period': '2025',
    },
  ];

  static const List<Map<String, String>> experiences = [
    {
      'title': 'Designer et monteur vidéo',
      'company': 'LEGEND STUDIO',
      'period': '2020 – 2021',
    },
  ];

  static const List<Map<String, String>> projects = [
    {
      'name': 'MultiChainExplorer',
      'description':
          'Explorateur multichaîne permettant de consulter '
          'des informations issues de plusieurs réseaux blockchain.',
      'technologies': 'React • TypeScript • Vite',
    },
    {
      'name': 'Kenda',
      'description':
          'Solution de gestion des infractions routières '
          'avec une approche basée sur la blockchain Cardano.',
      'technologies': 'Next.js • Supabase • Cardano • MeshJS',
    },
    {
      'name': 'MalobaBridge / LinguaVox',
      'description':
          'Projet de traduction vocale et de valorisation '
          'des langues africaines.',
      'technologies': 'React • Supabase • IA • Speech Technologies',
    },
    {
      'name': 'Bitcoin Wallet Lab',
      'description':
          'Laboratoire expérimental autour des portefeuilles '
          'Bitcoin et des interactions avec un bot Telegram.',
      'technologies': 'Bitcoin Core • Node.js • Telegram Bot',
    },
  ];

  static const Map<String, List<String>> skills = {
    'Développement': [
      'JavaScript',
      'TypeScript',
      'React',
      'Node.js',
      'React Native',
      'Express',
    ],
    'Bases de données': [
      'PostgreSQL',
      'Supabase',
    ],
    'Blockchain & Web3': [
      'Bitcoin',
      'Cardano',
      'Sui',
      'Smart Contracts',
    ],
    'Création numérique': [
      'Photographie',
      'Montage vidéo',
      'Bureautique',
    ],
  };

  static const Map<String, String> languages = {
    'Français': 'Langue de communication',
    'Anglais': 'Intermédiaire',
  };

  static const List<String> interests = [
    'Intelligence artificielle',
    'Blockchain & Web3',
    'Développement logiciel',
    'Innovation technologique',
    'Photographie',
    'Création audiovisuelle',
  ];
}
