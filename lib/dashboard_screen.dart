import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250, // Max width for each item
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2, // Controls height relative to width
            ),
            children: _buildAdminSettings(),
          ),
        ),
      ),
    );
  }
}

//
List<Widget> _buildAdminSettings() {
  return [
    _buildAdminCard(
      title: 'Add Brand',
      subtitle: 'Add product brand',
      icon: Iconsax.briefcase,
      routeName: '/brands',
    ),
    _buildAdminCard(
      title: 'Add Category',
      subtitle: 'Add product category ',
      icon: Iconsax.category,
      routeName: '/categories',
    ),
    _buildAdminCard(
      title: 'Add Product',
      subtitle: 'Add product details',
      icon: Iconsax.shop,
      routeName: '/products',
    ),
  ];
}

//
Widget _buildAdminCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required String routeName,
}) {
  return GestureDetector(
    onTap: () => Get.toNamed(routeName),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blueAccent),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
