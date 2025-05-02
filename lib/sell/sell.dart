import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../products/product_details.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<ProductModel, int> selectedProducts = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

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
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SellDrawer(),
      appBar: AppBar(
        title: const Text('Sell Product'),
      ),
      //
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search product',
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
              const SizedBox(height: 16),

              //
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

                    return ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        var doc = products[index];
                        int reversedIndex =
                            products.length - index; // Reverse index
                        String imageUrl = doc['images'] != null &&
                                (doc['images'] as List).isNotEmpty
                            ? doc['images'][0]
                            : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'; // Placeholder image

                        final product = ProductModel.fromQuerySnapshot(doc);

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
                                              product: ProductModel
                                                  .fromQuerySnapshot(doc)));
                                        },
                                        child: Container(
                                          width: 72,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  imageUrl), // Cached Image
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      //
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${doc['name']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
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

                                    const SizedBox(height: 8),

                                    //
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                      (doc['regularPrice']
                                                              as num)
                                                          .toStringAsFixed(0),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      (doc['salePrice'] as num)
                                                          .toStringAsFixed(0),
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      (doc['costPrice'] as num)
                                                          .toStringAsFixed(0),
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                        Obx(() {
                                          int quantity = cartController
                                              .getQuantity(product);

                                          return Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: quantity > 0
                                                    ? () {
                                                        cartController
                                                            .removeFromCart(
                                                                product);
                                                      }
                                                    : null,
                                              ),
                                              Text('$quantity'),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  cartController
                                                      .addToCart(product);
                                                  _scaffoldKey.currentState!
                                                      .openEndDrawer();
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),

                                //
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
class SellDrawer extends StatefulWidget {
  const SellDrawer({
    super.key,
  });

  @override
  State<SellDrawer> createState() => _SellDrawerState();
}

class _SellDrawerState extends State<SellDrawer> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final discountController = TextEditingController();
  final CartController cartController = Get.find<CartController>();

  String discountType = 'Direct';

  double calculateTotal() {
    double subtotal = 0;
    for (var entry in cartController.cartItems.entries) {
      subtotal += entry.key.salePrice * entry.value;
    }

    double rawDiscount = double.tryParse(discountController.text) ?? 0;
    double discountAmount =
        discountType == 'Direct' ? rawDiscount : subtotal * (rawDiscount / 100);

    return (subtotal - discountAmount).clamp(0, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12,
      width: 400,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sell Summary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      //close drawer
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),

            Obx(() {
              if (cartController.cartItems.isNotEmpty) {
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Name',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: mobileController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mobile Number (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reactive cart item list
                      Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children:
                                cartController.cartItems.entries.map((entry) {
                              final product = entry.key;
                              final quantity = entry.value;

                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  //
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Stack(
                                      children: [
                                        //
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                              ),
                                              child: Image.network(
                                                product.images.isNotEmpty
                                                    ? product.images.first
                                                    : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 10),

                                            //
                                            Expanded(
                                              child: Column(
                                                spacing: 4,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(product.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      '৳ ${product.salePrice} x $quantity = ৳ ${product.salePrice * quantity}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        //
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    size: 16),
                                                onPressed: quantity > 1
                                                    ? () => cartController
                                                        .removeFromCart(product)
                                                    : null,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 24),
                                                  child: Text('$quantity')),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    size: 16),
                                                onPressed:
                                                    quantity < product.stock
                                                        ? () => cartController
                                                            .addToCart(product)
                                                        : null,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //
                                  Positioned(
                                    top: -8,
                                    right: -8,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 16, color: Colors.red),
                                      onPressed: () {
                                        cartController.cartItems
                                            .remove(product);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle()),
                          Obx(() {
                            double subtotal =
                                cartController.cartItems.entries.fold(
                              0.0,
                              (prev, e) => prev + e.key.salePrice * e.value,
                            );
                            return Text('৳ ${subtotal.toStringAsFixed(0)}',
                                style: const TextStyle());
                          }),
                        ],
                      ),

                      const SizedBox(height: 8),

                      //
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Discount'),

                          const SizedBox(height: 8),

                          // Discount Input
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: discountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) {
                                    double val = double.tryParse(
                                            discountController.text) ??
                                        0;
                                    if (discountType == 'Percentage' &&
                                        val > 100) {
                                      discountController.text = '100';
                                      discountController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset:
                                                discountController.text.length),
                                      );
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Discount Type Toggle (Taka / Percent)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          discountType = 'Direct';
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: discountType == 'Direct'
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(3),
                                              bottomLeft: Radius.circular(3)),
                                        ),
                                        child: Text(
                                          'Taka',
                                          style: TextStyle(
                                            color: discountType == 'Direct'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          discountType = 'Percentage';
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: discountType == 'Percentage'
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(3),
                                              bottomRight: Radius.circular(3)),
                                        ),
                                        child: Text(
                                          'Percent',
                                          style: TextStyle(
                                            color: discountType == 'Percentage'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              const Spacer(),

                              // Show Calculated Discount Amount
                              Obx(() {
                                double subtotal =
                                    cartController.cartItems.entries.fold(
                                  0.0,
                                  (prev, e) => prev + e.key.salePrice * e.value,
                                );
                                double rawDiscount =
                                    double.tryParse(discountController.text) ??
                                        0;
                                double discountAmount = discountType == 'Direct'
                                    ? rawDiscount
                                    : subtotal * (rawDiscount / 100);

                                return Text(
                                  '- ৳ ${discountAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                );
                              })
                            ],
                          ),
                        ],
                      ),

                      //
                      const Divider(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Obx(
                            () => Text(calculateTotal().toStringAsFixed(0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No item selected!'));
              }
            }),

            //
            Obx(() {
              if (cartController.cartItems.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty) return;

                            for (var entry
                                in cartController.cartItems.entries) {
                              final product = entry.key;
                              final quantity = entry.value;

                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(product.id)
                                  .update({
                                'stock': FieldValue.increment(-quantity),
                              });

                              await FirebaseFirestore.instance
                                  .collection('sales')
                                  .add({
                                'productId': product.id,
                                'name': nameController.text.trim(),
                                'mobile': mobileController.text.trim(),
                                'quantity': quantity,
                                'unitPrice': product.salePrice,
                                'discountType': discountType,
                                'discountValue':
                                    double.tryParse(discountController.text) ??
                                        0,
                                'discountAmount': 0,
                                'total': product.salePrice * quantity,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            }

                            cartController.clearCart();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Products sold successfully!')),
                            );
                          },
                          child: const Text('Confirm Sale'),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox(); // Return empty widget if cart is empty
              }
            }),
          ],
        ),
      ),
    );
  }
}
