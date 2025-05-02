import 'package:get/get.dart';

import '../models/product_model.dart';

class CartController extends GetxController {
  // Reactive map to store selected products and their quantities
  final RxMap<ProductModel, int> cartItems = <ProductModel, int>{}.obs;

  void addToCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
  }

  void removeFromCart(ProductModel product) {
    if (!cartItems.containsKey(product)) return;

    if (cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
    } else {
      cartItems.remove(product);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  int getQuantity(ProductModel product) {
    return cartItems[product] ?? 0;
  }

  int get totalItems => cartItems.length;

  int get totalQuantity => cartItems.values.fold(0, (sum, qty) => sum + qty);
}
