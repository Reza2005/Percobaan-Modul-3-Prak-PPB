import 'package:flutter/material.dart';

// Class untuk merepresentasikan data anggota
class Member {
  final String name;
  final String nim;
  final String group;
  final String shift;
  final String photoAsset;

  const Member({
    required this.name,
    required this.nim,
    required this.group,
    required this.shift,
    required this.photoAsset,
  });
}

class ProfilePage extends StatelessWidget {
  // Daftar anggota kelompok
  final List<Member> groupMembers = const [
    Member(
      name: "Rhea Alya Khaerunnisa",
      nim: "21120123130088",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_satu.jpg",
    ),
    Member(
      name: "Anisa Anastasya",
      nim: "21120123130080",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_dua.jpg",
    ),
    Member(
      name: "Salsabila Diva",
      nim: "21120123140044",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_tiga.jpg",
    ),
    Member(
      name: "Muhamad Reswara Suryawan",
      nim: "21120123140126",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_empat.jpg",
    ),
  ];

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Kelompok 22'),
      ),
      body: Stack( // Stack untuk menumpuk background dan list
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://cdn.myanimelist.net/s/common/uploaded_files/1444014275-106dee95104209bb9436d6df2b6d5145.jpeg',
                ),
                fit: BoxFit.cover,
                // Membuat gambar sedikit gelap agar teks lebih mudah dibaca
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // ListView untuk menampilkan anggota
          ListView.builder(
            itemCount: groupMembers.length,
            itemBuilder: (context, index) {
              final member = groupMembers[index];
              return Card(
                // Membuat card sedikit transparan
                color: Colors.white.withOpacity(0.85),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(member.photoAsset),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIM: ${member.nim}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kelompok: ${member.group} | Shift: ${member.shift}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}