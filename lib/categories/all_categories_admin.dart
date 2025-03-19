// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../models/category_model.dart';
// import 'add_category.dart';
// import 'edit_category.dart';
//
// class AllCategoriesAdmin extends StatelessWidget {
//   const AllCategoriesAdmin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories'),
//       ),
//
//       //
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton.icon(
//           onPressed: () {
//             Get.to(() => const AddCategory());
//           },
//           label: const Text('Add Category'),
//           icon: const Icon(
//             Iconsax.add_circle,
//             size: 18,
//           ),
//         ),
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('categories')
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
//                   scrollDirection: Axis.horizontal,
//                   child: Scrollbar(
//                     scrollbarOrientation: ScrollbarOrientation.right,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
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
//                                 // parent category
//                                 TableCell(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         'Parent Category',
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
//                                   // parent
//                                   TableCell(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(docs[i]['parentId'] ?? ''),
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
//                                               final category = CategoryModel
//                                                   .fromQuerySnapshot(docs[i]);
//                                               Get.to(() => EditCategory(
//                                                   category: category));
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
//                       .collection('categories')
//                       .doc(categoryId)
//                       .delete();
//                   Get.snackbar(
//                     'Success',
//                     'Category deleted successfully',
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

import 'package:abrar_admin/categories/product_by_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';
import 'edit_category.dart';

class AllCategoriesAdmin extends StatefulWidget {
  const AllCategoriesAdmin({super.key});

  @override
  State<AllCategoriesAdmin> createState() => _AllCategoriesAdminState();
}

class _AllCategoriesAdminState extends State<AllCategoriesAdmin> {
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
        title: const Text('Categories'),
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
                        labelText: 'Search category',
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
                      Get.toNamed('/categories/add-category');
                    },
                    child: const Text('Add Category'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .orderBy('createdDate', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var categories = snapshot.data!.docs;
                    if (_searchQuery.isNotEmpty) {
                      categories = categories.where((doc) {
                        return doc['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery);
                      }).toList();
                    }

                    return isTableView
                        ? _buildTableView(categories)
                        : _buildListView(categories);
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
  Widget _buildTableView(List<QueryDocumentSnapshot> categories) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Vertical scrolling
          child: DataTable(
            border: TableBorder.all(color: Colors.black12),
            headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Image')),
              DataColumn(
                label: Text('Name'),
                columnWidth: FixedColumnWidth(380),
              ),
              DataColumn(label: Text('Slug')),
              DataColumn(label: Text('Featured')),
              DataColumn(label: Text('Actions')),
            ],
            rows: List.generate(categories.length, (index) {
              var doc = categories[index];
              return DataRow(cells: [
                DataCell(Text('${categories.length - index}')),
                DataCell(
                  doc['imageUrl'].isNotEmpty
                      ? Image.network(doc['imageUrl'], width: 40, height: 40)
                      : const Icon(Icons.image_not_supported),
                ),
                DataCell(Text(doc['name'])),
                DataCell(Text(doc['slug'])),
                DataCell(
                  Center(
                    // Center the icon in the 'Featured' column
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
                        final category = CategoryModel.fromQuerySnapshot(doc);
                        Get.to(() => EditCategory(category: category));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        _showDeleteDialog(doc.id);
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
  Widget _buildListView(List<QueryDocumentSnapshot> categories) {
    return ListView.separated(
      separatorBuilder: (_, i) => const SizedBox(height: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var doc = categories[index];

        //
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  //
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ProductByCategory(category: doc["name"]));
                    },
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(doc['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  //
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),

                        //
                        Row(
                          spacing: 4,
                          children: [
                            const Text(
                              "Slug: ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(doc['slug']),
                          ],
                        ),

                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //
                            Text(
                              doc['isFeatured'] ? 'Featured' : 'Not Featured',
                            ),

                            Spacer(),

                            //
                            IconButton(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                final category =
                                    CategoryModel.fromQuerySnapshot(doc);
                                Get.to(() => EditCategory(category: category));
                              },
                            ),
                            IconButton(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _showDeleteDialog(doc.id);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),

              //
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${categories.length - index}',
                  style: const TextStyle(fontSize: 10),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  //
  void _showDeleteDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
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
