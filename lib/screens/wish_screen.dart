import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/producty_model.dart';
import 'add_product_screen.dart';
import 'product_details_screen.dart';

class WishScreen extends StatefulWidget {
  const WishScreen({super.key});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Wish List',
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
                      const AddProductScreen(isWishlistMode: true),
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
              final wishProducts =
                  box.values.where((e) => e.isInWishlist == true).toList();

              final categories = <String>{
                ...wishProducts
                    .map((e) => e.category)
                    .where((e) => e.isNotEmpty)
              };

              final filtered = selectedCategory == 'All'
                  ? wishProducts
                  : wishProducts
                      .where((p) => p.category == selectedCategory)
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (wishProducts.isNotEmpty)
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
                  if (wishProducts.isNotEmpty) SizedBox(height: 16.h),
                  if (wishProducts.isEmpty)
                    Image.asset(
                      'assets/images/wish.png',
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  if (wishProducts.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            },
          ),
        ),
      ),
    );
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final box = GetIt.I.get<Box<ProductyModel>>();
                        await box.put(
                          product.id,
                          product.copyWith(
                            isInWishlist: false,
                            link: '',
                            stars: '0',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3DC6FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Bought',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
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
