import 'package:cloud_firestore/cloud_firestore.dart';
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
          child: SingleChildScrollView(
            child: Column(
              spacing: 32,
              children: [
                //
                const PriceSection(),

                //

                //
                GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250, // Max width for each item
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2, // Controls height relative to width
                  ),
                  children: _buildAdminSettings(),
                ),
              ],
            ),
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
    _buildAdminCard(
      title: 'Sell Product',
      subtitle: 'Sell product from shop',
      icon: Iconsax.bill,
      routeName: '/sell',
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

//
class PriceSection extends StatelessWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return _buildLoadingContainer();
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        double totalBuyPrice = 0;
        int totalProducts = docs.length;
        int totalStock = 0;

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final double buyPrice = (data['costPrice'] ?? 0).toDouble();
          final int stock = (data['stock'] ?? 0).toInt();

          totalBuyPrice += buyPrice * stock;
          totalStock += stock;
        }

        return _buildPriceContainer(totalBuyPrice, totalProducts, totalStock);
      },
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPriceContainer(
      double totalBuyPrice, int totalProducts, int totalStock) {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Total Product Costing:"),
          Text(
            "৳ ${totalBuyPrice.toStringAsFixed(0)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
            textScaler: const TextScaler.linear(2),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: [
              Text("Total Products: $totalProducts"),
              const Text(" | ", style: TextStyle(fontSize: 12)),
              Text("Total Stock: $totalStock"),
            ],
          ),
        ],
      ),
    );
  }
}
