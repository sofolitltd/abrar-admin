import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../products/add_products.dart';
import '../products/edit_products.dart';
import '../products/product_details.dart';

class ProductByCategory extends StatefulWidget {
  const ProductByCategory({super.key, required this.category});

  final String category;

  @override
  State<ProductByCategory> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  final TextEditingController _searchController = TextEditingController();
  bool isTableView = false; // Toggle between Table and List (Cards) View
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          // Toggle List / Table View Button
          IconButton(
            icon: Icon(isTableView ? Icons.view_list : Icons.table_chart),
            onPressed: () {
              setState(() {
                isTableView = !isTableView;
              });
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field & Add Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search product',
                        contentPadding:
                            const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        suffixIconConstraints: const BoxConstraints(
                          minHeight: 32,
                          minWidth: 32,
                        ),
                        suffixIcon: InkWell(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.clear,
                              size: 16,
                            )),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showAddProductDialog,
                  child: const Text('Add Product'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // StreamBuilder for products
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('createdDate', descending: true)
                    .where('category', isEqualTo: widget.category)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var products = snapshot.data!.docs;

                  // Search functionality
                  if (_searchQuery.isNotEmpty) {
                    products = products.where((doc) {
                      return doc['name']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          doc['category']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          doc['brand']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery);
                    }).toList();
                  }

                  return isTableView
                      ? _buildWebView(products)
                      : _buildMobileView(products);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌐 Table View (Now Scrollable)
  Widget _buildWebView(List<QueryDocumentSnapshot> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      child: SingleChildScrollView(
        child: DataTable(
          // columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
          border: TableBorder.all(color: Colors.black12),
          columns: const [
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.asMap().entries.map((entry) {
            int index = products.length - entry.key; // Reverse index
            var doc = entry.value;
            String imageUrl =
                doc['images'] != null && (doc['images'] as List).isNotEmpty
                    ? doc['images'][0] // First image
                    : 'https://via.placeholder.com/80'; // Placeholder image

            return DataRow(cells: [
              DataCell(Text(index.toString())),
              DataCell(GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetails(
                      product: ProductModel.fromQuerySnapshot(doc)));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.network(
                    imageUrl,
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              DataCell(Text(doc['name'])),
              DataCell(Text(doc['category'])),
              DataCell(Text(doc['brand'])),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(() => EditProduct(
                          product: ProductModel.fromQuerySnapshot(doc)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('products')
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  /// 📱 Mobile View (With Delete & Edit Buttons)
  Widget _buildMobileView(List<QueryDocumentSnapshot> products) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        var doc = products[index];
        int reversedIndex = products.length - index; // Reverse index
        String imageUrl =
            doc['images'] != null && (doc['images'] as List).isNotEmpty
                ? doc['images'][0]
                : 'https://via.placeholder.com/80';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(spacing: 16, children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetails(
                              product: ProductModel.fromQuerySnapshot(doc)));
                        },
                        child: Container(
                          width: 72,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imageUrl),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      //
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${doc['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            //
                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Category:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text('${doc['category']}'),
                              ],
                            ),

                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Brand:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text('${doc['brand']}'),
                              ],
                            ),

                            //
                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Stock:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  doc['stock'] == 0
                                      ? 'Out of Stock'
                                      : '${doc['stock']}',
                                  style: TextStyle(
                                    color: doc['stock'] == 0
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),

                    // Edit & Delete Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            //
                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Price:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (doc['regularPrice'] as num)
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            //
                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Sale:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (doc['salePrice'] as num).toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Spacer(),
                        //
                        IconButton(
                          onPressed: () {
                            Get.to(() => EditProduct(
                                product: ProductModel.fromQuerySnapshot(doc)));
                          },
                          icon: const Icon(Icons.edit, color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('products')
                                .doc(doc.id)
                                .delete();
                          },
                          icon: const Icon(Icons.delete, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                //
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    reversedIndex.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog() {
    Get.to(() => const AddProduct());
  }
}
