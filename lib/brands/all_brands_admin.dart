// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../models/brand_model.dart';
// import 'add_brand.dart';
// import 'edit_brand.dart';
//
// class AllBrandsAdmin extends StatelessWidget {
//   const AllBrandsAdmin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Brands'),
//       ),
//
//       //
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton.icon(
//           onPressed: () {
//             Get.to(() => const AddBrand());
//           },
//           label: const Text('Add Brand'),
//           icon: const Icon(
//             Iconsax.add_circle,
//             size: 18,
//           ),
//         ),
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('brands')
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
//             return const Center(child: Text('No data found'));
//           }
//
//           final docs = snapshot.data!.docs;
//           return Center(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Scrollbar(
//                 scrollbarOrientation: ScrollbarOrientation.bottom,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Scrollbar(
//                     scrollbarOrientation: ScrollbarOrientation.right,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Table(
//                           border: TableBorder.all(color: Colors.black12),
//                           defaultColumnWidth: const IntrinsicColumnWidth(),
//                           defaultVerticalAlignment:
//                               TableCellVerticalAlignment.middle,
//                           children: [
//                             const TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                               ),
//                               children: [
//                                 //
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'No',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 //
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Image',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 //name
//
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Name',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // slug
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Slug',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // featured
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Featured',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // actions
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Actions',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             //
//                             for (var i = 0; i < docs.length; i++)
//                               TableRow(
//                                 children: [
//                                   //
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         '${i + 1}',
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   //image
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Container(
//                                         height: 40,
//                                         width: 40,
//                                         decoration: BoxDecoration(
//                                           border:
//                                               Border.all(color: Colors.black12),
//                                           color: Colors.blueAccent.shade100
//                                               .withOpacity(.2),
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           image: docs[i]['imageUrl'].isNotEmpty
//                                               ? DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage(
//                                                       docs[i]['imageUrl']),
//                                                 )
//                                               : null,
//                                         ),
//                                         // Assuming imageUrl is a valid image URL
//                                       ),
//                                     ),
//                                   ),
//
//                                   // name
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         docs[i]['name'],
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   //slug
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(docs[i]['slug']),
//                                     ),
//                                   ),
//
//                                   // featured
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Center(
//                                         child: docs[i]['isFeatured'] != true
//                                             ? const Icon(
//                                                 Icons.favorite_border,
//                                                 color: Colors.grey,
//                                               )
//                                             : const Icon(
//                                                 Icons.favorite,
//                                                 color: Colors.blueAccent,
//                                               ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   // action
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           IconButton(
//                                             style: IconButton.styleFrom(
//                                               visualDensity:
//                                                   const VisualDensity(
//                                                 vertical: -3,
//                                                 horizontal: -3,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               final brand =
//                                                   BrandModel.fromJson(docs[i]);
//                                               Get.to(() =>
//                                                   EditBrand(brand: brand));
//                                             },
//                                             icon: const Icon(
//                                               Icons.edit,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
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
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // delete dialog
//   Future<void> showDeleteConfirmationDialog(
//       BuildContext context, String categoryId) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Are you sure you want to delete this brand?'),
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
//                       .collection('brands')
//                       .doc(categoryId)
//                       .delete();
//                   Get.snackbar(
//                     'Success',
//                     'Brand deleted successfully',
//                     colorText: Colors.white,
//                     backgroundColor: Colors.green,
//                   );
//                 } catch (e) {
//                   Get.snackbar(
//                     'Error',
//                     'Failed to delete brand: $e',
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

import '../models/brand_model.dart';
import 'edit_brand.dart';

class AllBrandsAdmin extends StatefulWidget {
  const AllBrandsAdmin({super.key});

  @override
  State<AllBrandsAdmin> createState() => _AllBrandsAdminState();
}

class _AllBrandsAdminState extends State<AllBrandsAdmin> {
  final TextEditingController _searchController = TextEditingController();
  bool isTableView = false;
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
        title: const Text('Brands'),
        actions: [
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search brand',
                        contentPadding:
                            const EdgeInsets.fromLTRB(12, 12, 0, 12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/brands/add-brand');
                    },
                    child: const Text('Add Brand'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('brands')
                      .orderBy('createdDate', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var brands = snapshot.data!.docs;
                    if (_searchQuery.isNotEmpty) {
                      brands = brands.where((doc) {
                        return doc['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery);
                      }).toList();
                    }

                    return isTableView
                        ? _buildTableView(brands)
                        : _buildListView(brands);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Widget _buildTableView(List<QueryDocumentSnapshot> brands) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            border: TableBorder.all(color: Colors.black12),
            headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Image')),
              DataColumn(
                label: Text('Name'),
                columnWidth: FixedColumnWidth(390),
              ),
              DataColumn(label: Text('Slug')),
              DataColumn(label: Text('Featured')),
              DataColumn(label: Text('Actions')),
            ],
            rows: List.generate(brands.length, (index) {
              var doc = brands[index];
              return DataRow(cells: [
                DataCell(Text('${brands.length - index}')),
                DataCell(
                  doc['imageUrl'].isNotEmpty
                      ? Image.network(doc['imageUrl'], width: 40, height: 40)
                      : const Icon(Icons.image_not_supported),
                ),
                DataCell(Text(doc['name'])),
                DataCell(Text(doc['slug'])),
                DataCell(
                  Center(
                    child: doc['isFeatured']
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  ),
                ),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () {
                        final brand = BrandModel.fromJson(doc);
                        Get.to(() => EditBrand(brand: brand));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        showDeleteConfirmationDialog(context, doc.id);
                      },
                    ),
                  ],
                )),
              ]);
            }),
          ),
        ),
      ),
    );
  }

  //
  Widget _buildListView(List<QueryDocumentSnapshot> brands) {
    return ListView.separated(
      separatorBuilder: (_, i) => const SizedBox(height: 16),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        var doc = brands[index];

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Row(
                spacing: 16,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to ProductByBrand or related screen
                    },
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blueAccent.shade100.withValues(alpha: .2),
                        image: DecorationImage(
                          image: NetworkImage(doc['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Text(
                          doc['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Slug: ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(doc['slug']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(doc['isFeatured']
                                ? 'Featured'
                                : 'Not Featured'),

                            //
                            const Spacer(),

                            //
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                final brand = BrandModel.fromJson(doc);
                                Get.to(() => EditBrand(brand: brand));
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showDeleteConfirmationDialog(context, doc.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${brands.length - index}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String brandId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this brand?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('brands')
                      .doc(brandId)
                      .delete();
                  Get.snackbar(
                    'Success',
                    'Brand deleted successfully',
                    colorText: Colors.white,
                    backgroundColor: Colors.green,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to delete brand: $e',
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
