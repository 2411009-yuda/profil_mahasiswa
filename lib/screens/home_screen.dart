import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../models/course.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/lifecycle_badge.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/um_widgets.dart';

/// Layar 1: Beranda. Ringkasan profil, menu, dan daftar mata kuliah.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final student = vm.student;

    return Scaffold(
      appBar: umAppBar('Beranda'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroCard(
            nama: student.nama,
            prodi: student.programStudi,
            semester: student.semester,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MenuButton(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MenuButton(
                  icon: Icons.contact_mail_outlined,
                  label: 'Kontak',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.contact),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Mata Kuliah Semester ${student.semester}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: UmColors.navy),
          ),
          const SizedBox(height: 2),
          Text('${vm.courses.length} mata kuliah · ${vm.totalSks} SKS'),
          const SizedBox(height: 8),
          for (final course in vm.courses) _CourseTile(course: course),
          const SizedBox(height: 16),
          const LifecycleBadge(),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.nama,
    required this.prodi,
    required this.semester,
  });

  final String nama;
  final String prodi;
  final int semester;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UmColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: UmColors.yellow,
              shape: BoxShape.circle,
            ),
            child: const ProfileAvatar(radius: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selamat datang,',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 2),
                Text(
                  nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(prodi, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: UmColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Semester $semester',
                    style: const TextStyle(
                      color: UmColors.navy,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SectionCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: const CircleAvatar(
            backgroundColor: UmColors.blue,
            child: Icon(Icons.menu_book_outlined, color: Colors.white),
          ),
          title: Text(course.nama),
          subtitle: Text('${course.kode} · ${course.sks} SKS'),
          trailing: const Icon(Icons.chevron_right),
          // Data dikirim seperlunya: cukup id mata kuliah.
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.courseDetail,
            arguments: course.kode,
          ),
        ),
      ),
    );
  }
}
