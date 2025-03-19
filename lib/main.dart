import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/brands/add_brand.dart';
import '/brands/all_brands_admin.dart';
import '/categories/add_category.dart';
import '/categories/all_categories_admin.dart';
import '/dashboard_screen.dart';
import '/products/add_products.dart';
import '/products/all_products_admin.dart';
import 'firebase_options.dart';

// firebase deploy --only hosting:abraradmin

//
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Abrar Shop - Admin',
      theme: ThemeData(
        fontFamily: 'Telenor',
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: appRoutes,
    );
  }
}

//
List<GetPage> appRoutes = [
  GetPage(name: '/', page: () => const DashboardScreen()),
  GetPage(name: '/brands', page: () => const AllBrandsAdmin()),
  GetPage(name: '/brands/add-brand', page: () => const AddBrand()),
  GetPage(name: '/categories', page: () => const AllCategoriesAdmin()),
  GetPage(name: '/categories/add-category', page: () => const AddCategory()),
  GetPage(name: '/products', page: () => const AllProductsAdmin()),
  GetPage(name: '/products/add-product', page: () => const AddProduct()),
];
