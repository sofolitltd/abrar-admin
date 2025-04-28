// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../models/product_model.dart';
// import '../utils/k_text.dart';
// import 'add_products.dart';
// import 'edit_products.dart';
// import 'product_details.dart';
//
// class AllProductsAdmin extends StatefulWidget {
//   const AllProductsAdmin({super.key});
//
//   @override
//   State<AllProductsAdmin> createState() => _AllProductsAdminState();
// }
//
// class _AllProductsAdminState extends State<AllProductsAdmin> {
//   bool _isList = true;
//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.toLowerCase();
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Products'),
//       ),
//
//       //
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton.icon(
//           onPressed: () {
//             Get.to(() => const AddProduct());
//           },
//           label: const Text('Add Product'),
//           icon: const Icon(
//             Iconsax.add_circle,
//             size: 18,
//           ),
//         ),
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('products')
//             .orderBy('createdDate', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No products found'));
//           }
//
//           final docs = snapshot.data!.docs;
//
//           // Filtering locally based on search query
//           final filteredDocs = docs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final name = data['name']?.toString().toLowerCase() ?? '';
//             final category = data['category']?.toString().toLowerCase() ?? '';
//             final brand = data['brand']?.toString().toLowerCase() ?? '';
//
//             return name.contains(_searchQuery) ||
//                 category.contains(_searchQuery) ||
//                 brand.contains(_searchQuery);
//           }).toList();
//
//           //
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: [
//                     //
//                     Row(
//                       children: [
//                         //
//                         Text('Total Product: ${docs.length}'),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isList = true;
//                             });
//                           },
//                           child: Icon(
//                             Icons.list_alt,
//                             color: _isList ? Colors.black : Colors.black26,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isList = false;
//                             });
//                           },
//                           child: Icon(
//                             Icons.grid_view,
//                             color: _isList ? Colors.black26 : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     //
//                     const SizedBox(height: 12),
//
//                     //
//                     TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search product',
//                         // prefixIcon: Icon(Icons.search),
//                         contentPadding:
//                             const EdgeInsets.fromLTRB(12, 12, 0, 12),
//                         suffixIcon: GestureDetector(
//                           child: const Icon(Icons.clear),
//                           onTap: () {
//                             setState(() {
//                               _searchController.clear();
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       //clear by click x
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value.toLowerCase();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//               //
//
//               if (_isList == true)
//                 Expanded(
//                   child: Scrollbar(
//                     child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: filteredDocs.length,
//                         separatorBuilder: (context, index) =>
//                             const SizedBox(height: 10),
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 16,
//                         ),
//                         itemBuilder: (context, i) {
//                           //
//                           return Container(
//                             padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black12),
//                             ),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 // img
//                                 GestureDetector(
//                                   onTap: () {
//                                     ProductModel product =
//                                         ProductModel.fromQuerySnapshot(
//                                             filteredDocs[i]);
//                                     //
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ProductsDetails(product: product),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     height: 100,
//                                     width: 80,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.black12),
//                                       color: Colors.blueAccent.shade100
//                                           .withValues(alpha: .2),
//                                       borderRadius: BorderRadius.circular(5),
//                                       image: docs[i]['images'].isNotEmpty
//                                           ? DecorationImage(
//                                               fit: BoxFit.cover,
//                                               image: NetworkImage(
//                                                   docs[i]['images'][0]),
//                                             )
//                                           : null,
//                                     ),
//                                     // Assuming imageUrl is a valid image URL
//                                   ),
//                                 ),
//
//                                 const SizedBox(width: 12),
//
//                                 //
//                                 Expanded(
//                                   child: Stack(
//                                     alignment: Alignment.bottomRight,
//                                     children: [
//                                       //
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // name
//                                           KText(
//                                             docs[i]['name'],
//                                             maxLines: 1,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//
//                                           //
//                                           Row(
//                                             children: [
//                                               // category
//                                               if (docs[i]['category'] != '')
//                                                 Text(
//                                                     'Category: ${docs[i]['category']}'),
//                                               const SizedBox(width: 4),
//
//                                               // sub
//                                               if (docs[i]['subCategory'] != '')
//                                                 Text(
//                                                     '/ ${docs[i]['subCategory']}'),
//                                             ],
//                                           ),
//
//                                           // brand
//                                           if (docs[i]['brand'] != '')
//                                             Text('Brand: ${docs[i]['brand']}'),
//
//                                           // price
//                                           Row(
//                                             children: [
//                                               Text(
//                                                   'Price: ${docs[i]['regularPrice'].toStringAsFixed(0)}'),
//                                               const SizedBox(width: 16),
//                                               Text(
//                                                   'Sale Price: ${docs[i]['salePrice'].toStringAsFixed(0)}'),
//                                             ],
//                                           ),
//
//                                           //stock
//                                           Text(
//                                             'Stock: ${docs[i]['stock']}',
//                                             style: const TextStyle(
//                                                 color: Colors.red),
//                                           ),
//
//                                           //featured
//                                           Container(
//                                             child: docs[i]['isFeatured'] != true
//                                                 ? const Text(
//                                                     'Not Featured',
//                                                   )
//                                                 : const Text(
//                                                     'Featured',
//                                                     style: TextStyle(
//                                                       color: Colors.green,
//                                                     ),
//                                                   ),
//                                           ),
//
//                                           const SizedBox(height: 8),
//                                         ],
//                                       ),
//
//                                       // action
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           const Spacer(),
//                                           //
//                                           IconButton(
//                                             style: IconButton.styleFrom(
//                                               visualDensity:
//                                                   const VisualDensity(
//                                                 vertical: -3,
//                                                 horizontal: -3,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               final product = ProductModel
//                                                   .fromQuerySnapshot(docs[i]);
//                                               Get.to(() => EditProduct(
//                                                   product: product));
//                                             },
//                                             icon: const Icon(
//                                               Icons.edit,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//
//                                           //
//                                           IconButton(
//                                             style: IconButton.styleFrom(
//                                               visualDensity:
//                                                   const VisualDensity(
//                                                 vertical: -3,
//                                                 horizontal: -3,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               showDeleteConfirmationDialog(
//                                                   context, docs[i].id);
//                                             },
//                                             icon: Icon(
//                                               Icons.delete,
//                                               color: Colors.red.shade400,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                   ),
//                 )
//               else
//                 Expanded(
//                   child: Scrollbar(
//                     scrollbarOrientation: ScrollbarOrientation.bottom,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Scrollbar(
//                         scrollbarOrientation: ScrollbarOrientation.right,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.vertical,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Table(
//                               border: TableBorder.all(color: Colors.black12),
//                               defaultColumnWidth: const IntrinsicColumnWidth(),
//                               defaultVerticalAlignment:
//                                   TableCellVerticalAlignment.middle,
//                               children: [
//                                 const TableRow(
//                                   decoration: BoxDecoration(
//                                     color: Colors.black12,
//                                   ),
//                                   children: [
//                                     // no
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'No',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     //
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Image',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // name
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Name',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     //  category
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Category',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // sub
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'SubCategory',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // brand
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Brand',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // stock
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Stock',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // price
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Price',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // featured
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Featured',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // actions
//                                     TableCell(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             'Actions',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 //
//                                 for (var i = 0; i < docs.length; i++)
//                                   TableRow(
//                                     children: [
//                                       //no
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(0),
//                                           child: Text(
//                                             '${i + 1}',
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                       ),
//
//                                       // img
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             height: 40,
//                                             width: 40,
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Colors.black12),
//                                               color: Colors.blueAccent.shade100
//                                                   .withOpacity(.2),
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               image: docs[i]['images']
//                                                       .isNotEmpty
//                                                   ? DecorationImage(
//                                                       fit: BoxFit.cover,
//                                                       image: NetworkImage(
//                                                           docs[i]['images'][0]),
//                                                     )
//                                                   : null,
//                                             ),
//                                             // Assuming imageUrl is a valid image URL
//                                           ),
//                                         ),
//                                       ),
//
//                                       // name
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             docs[i]['name'],
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//
//                                       // category
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                               (docs[i]['category'] != '')
//                                                   ? '${docs[i]['category']}'
//                                                   : '-'),
//                                         ),
//                                       ),
//
//                                       // sub
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                               (docs[i]['subCategory'] != '')
//                                                   ? '${docs[i]['subCategory']}'
//                                                   : '--'),
//                                         ),
//                                       ),
//
//                                       // brand
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text((docs[i]['brand'] != '')
//                                               ? '${docs[i]['brand']}'
//                                               : '-'),
//                                         ),
//                                       ),
//
//                                       //stock
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             docs[i]['stock'].toString(),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                       ),
//
//                                       // price
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(docs[i]['salePrice']
//                                               .toStringAsFixed(0)),
//                                         ),
//                                       ),
//
//                                       //featured
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Center(
//                                             child: docs[i]['isFeatured'] != true
//                                                 ? const Icon(
//                                                     Icons.favorite_border,
//                                                     color: Colors.grey,
//                                                   )
//                                                 : const Icon(
//                                                     Icons.favorite,
//                                                     color: Colors.blueAccent,
//                                                   ),
//                                           ),
//                                         ),
//                                       ),
//
//                                       // action
//                                       TableCell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               IconButton(
//                                                 style: IconButton.styleFrom(
//                                                   visualDensity:
//                                                       const VisualDensity(
//                                                     vertical: -3,
//                                                     horizontal: -3,
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   final product = ProductModel
//                                                       .fromQuerySnapshot(
//                                                           docs[i]);
//                                                   Get.to(() => EditProduct(
//                                                       product: product));
//                                                 },
//                                                 icon: const Icon(
//                                                   Icons.edit,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                               IconButton(
//                                                 style: IconButton.styleFrom(
//                                                   visualDensity:
//                                                       const VisualDensity(
//                                                     vertical: -3,
//                                                     horizontal: -3,
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   showDeleteConfirmationDialog(
//                                                       context, docs[i].id);
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.delete,
//                                                   color: Colors.red.shade400,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // delete dialog
//   Future<void> showDeleteConfirmationDialog(
//       BuildContext context, String productId) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Are you sure you want to delete this category?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Delete'),
//               onPressed: () async {
//                 try {
//                   await FirebaseFirestore.instance
//                       .collection('products')
//                       .doc(productId)
//                       .delete();
//                   Get.snackbar(
//                     'Success',
//                     'Product deleted successfully',
//                     colorText: Colors.white,
//                     backgroundColor: Colors.green,
//                   );
//                 } catch (e) {
//                   Get.snackbar(
//                     'Error',
//                     'Failed to delete category: $e',
//                     colorText: Colors.white,
//                     backgroundColor: Colors.red,
//                   );
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import 'edit_products.dart';
import 'product_details.dart'; // Import Product Details Page

class AllProductsAdmin extends StatefulWidget {
  const AllProductsAdmin({super.key});

  @override
  State<AllProductsAdmin> createState() => _AllProductsAdminState();
}

class _AllProductsAdminState extends State<AllProductsAdmin> {
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

      //
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field & Add Product Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  Expanded(
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
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/products/add-product');
                    },
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
                      .orderBy('createdDate', descending: true) // Latest first
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
      ),
    );
  }

  /// 🌐 Table View (Now Scrollable)
  Widget _buildWebView(List<QueryDocumentSnapshot> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      child: SingleChildScrollView(
        child: DataTable(
          // columnSpacing: 8,
          headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
          border: TableBorder.all(color: Colors.black12),
          columns: const [
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Name'), columnWidth: FixedColumnWidth(200)),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.asMap().entries.map((entry) {
            int index = products.length - entry.key; // Reverse index
            var doc = entry.value;
            String imageUrl = doc['images'] != null &&
                    (doc['images'] as List).isNotEmpty
                ? doc['images'][0] // First image
                : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'; // Placeholder image

            return DataRow(cells: [
              DataCell(Text(index.toString())),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetails(
                        product: ProductModel.fromQuerySnapshot(doc)));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100.withValues(alpha: .02),
                      border: Border.all(color: Colors.black12),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(Text(doc['name'])),
              DataCell(Text(doc['category'])),
              DataCell(Text(doc['brand'])),
              DataCell(Text(doc['stock'].toString())),
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
                      _showDeleteDialog(doc.id);
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
        String imageUrl = doc['images'] != null &&
                (doc['images'] as List).isNotEmpty
            ? doc['images'][0]
            : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'; // Placeholder image

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(spacing: 16, children: [
                      //
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
                              image: NetworkImage(imageUrl), // Cached Image
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
                                  'Regular:',
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

                            //
                            Row(
                              spacing: 4,
                              children: [
                                const Text(
                                  'Cost:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (doc['costPrice'] as num).toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.blue,
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
                            _showDeleteDialog(doc.id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                //
                Container(
                  margin: const EdgeInsets.only(right: 8),
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

  //
  void _showDeleteDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId) // Reference the product to delete
                    .delete();
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
