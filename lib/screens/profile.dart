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
      photoAsset: "assets/images/profile_satu.jpg", // DIUBAH
    ),
    Member(
      name: "Anisa Anastasya",
      nim: "21120123130080",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_dua.jpg", // DIUBAH
    ),
    Member(
      name: "Salsabila Diva",
      nim: "21120123140044",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_tiga.jpg", // DIUBAH
    ),
    Member(
      name: "Muhamad Reswara Suryawan",
      nim: "21120123140126",
      group: "22",
      shift: "4",
      photoAsset: "assets/images/profile_empat.jpg", // DIUBAH
    ),
  ];

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Kelompok 22'),
      ),
      body: ListView.builder(
        itemCount: groupMembers.length,
        itemBuilder: (context, index) {
          final member = groupMembers[index];
          return Card(
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('NIM: ${member.nim}'),
                        const SizedBox(height: 4),
                        Text('Kelompok: ${member.group} | Shift: ${member.shift}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}