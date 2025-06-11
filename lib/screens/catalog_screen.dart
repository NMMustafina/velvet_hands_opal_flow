import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/producty_model.dart';
import 'add_product_screen.dart';
import 'product_details_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Catalog',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AddProductScreen(isWishlistMode: false),
                ),
              );
            },
            child: SvgPicture.asset('assets/icons/add.svg'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ValueListenableBuilder(
              valueListenable: GetIt.I.get<Box<ProductyModel>>().listenable(),
              builder: (context, Box<ProductyModel> box, _) {
                final allProducts =
                    box.values.where((e) => e.isInWishlist == false).toList();
                final categories = <String>{
                  ...allProducts
                      .map((e) => e.category)
                      .where((e) => e.isNotEmpty)
                };
                final filtered = selectedCategory == 'All'
                    ? allProducts
                    : allProducts
                        .where((p) => p.category == selectedCategory)
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (box.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('assets/icons/all.svg', 'All'),
                            SizedBox(width: 8.w),
                            ...categories.map((cat) => Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: _buildFilterButton(
                                      _getCategoryIcon(cat), cat),
                                )),
                          ],
                        ),
                      ),
                    if (box.isNotEmpty) SizedBox(height: 16.h),
                    if (allProducts.isEmpty)
                      Image.asset(
                        'assets/images/empty.png',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    if (allProducts.isNotEmpty)
                      Expanded(
                        child: GridView.builder(
                          itemCount: filtered.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            return _buildProductCard(product);
                          },
                        ),
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cream':
        return 'assets/icons/cream.svg';
      case 'mask':
        return 'assets/icons/mask.svg';
      case 'scrub':
        return 'assets/icons/scrub.svg';
      case 'milk':
        return 'assets/icons/milk.svg';
      case 'other':
        return 'assets/icons/other.svg';
      default:
        return 'assets/icons/other.svg';
    }
  }

  Widget _buildFilterButton(String icon, String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3DC6FF) : Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductyModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productyModel: product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: product.phottooo != null && product.phottooo!.isNotEmpty
                    ? Image.file(
                        File(product.phottooo!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.asset(
                        'assets/images/photo_placeholder.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  SizedBox(height: 2.h),
                  Text(product.nameee,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black,
                      )),
                  if ((product.barannd ?? '').isNotEmpty)
                    Text(product.barannd!,
                        style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                  SizedBox(height: 4.h),
                  Row(
                    children: List.generate(5, (i) {
                      final rating = int.tryParse(product.stars ?? '') ?? 0;
                      return Icon(
                        Icons.star,
                        size: 16.sp,
                        color: i < rating ? Colors.amber : Colors.grey.shade300,
                      );
                    }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
