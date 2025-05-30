import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../utils/constants.dart';
import '../utils/image_section.dart';
import '../utils/k_text.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    //
    // final cartController = Get.put(CartController());

    //
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: KText(
          product.name,
          style: const TextStyle(fontSize: 16),
        ),
      ),

      //
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                //
                ImageSection(images: product.images),

                const SizedBox(height: 8),

                //
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KText(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 16),

                      //
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    'Special Price',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(),
                                  ),
                                  const SizedBox(height: 10),

                                  Text(
                                    '$kTkSymbol ${product.salePrice.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          // fontSize: 27,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          //
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              height: 75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // regular
                                  Container(
                                    // width: 130,
                                    decoration: BoxDecoration(
                                      color: Colors.black12.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //
                                        Text(
                                          'Price:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                height: 1,
                                              ),
                                        ),

                                        const SizedBox(width: 16),

                                        Text(
                                          '$kTkSymbol ${product.regularPrice.toStringAsFixed(0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                                color: Colors.black87,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // stock
                                  Container(
                                    // width: 130,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black12.withValues(alpha: .05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //
                                        Text(
                                          'Stock:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                height: 1.1,
                                              ),
                                        ),
                                        const SizedBox(width: 8),

                                        Text(
                                          product.stock != 0
                                              ? '${product.stock}'
                                              : 'Out of Stock',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                                color: product.stock != 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      //
                      Text(
                        'Product Description',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                      ),

                      const SizedBox(height: 8),

                      //
                      KText(
                        product.description.isEmpty
                            ? '${product.name}, Special Price: ${product.salePrice.toStringAsFixed(0)}, Regular Price: ${product.regularPrice.toStringAsFixed(0)}'
                            : product.description,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              // fontWeight: FontWeight.bold,
                              height: 1.6,
                            ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
