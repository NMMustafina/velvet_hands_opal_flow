import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/producty_model.dart';

class SelectProductScreen extends StatefulWidget {
  const SelectProductScreen({super.key});

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(child: SvgPicture.asset('assets/icons/back.svg')),
        ),
        title: const Text(
          'Select a product',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ValueListenableBuilder(
            valueListenable: GetIt.I.get<Box<ProductyModel>>().listenable(),
            builder: (context, Box<ProductyModel> box, _) {
              final allProducts =
                  box.values.where((e) => !e.isInWishlist).toList();
              final categories = <String>{
                ...allProducts.map((e) => e.category).where((e) => e.isNotEmpty)
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
                  if (box.isEmpty)
                    Image.asset(
                      'assets/images/empty.png',
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  if (box.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return _buildSelectableCard(product);
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3DC6FF) : const Color(0xFFF6F6F6),
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

  Widget _buildSelectableCard(ProductyModel product) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, product),
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
                  Text(
                    product.category,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.nameee,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((product.barannd ?? '').isNotEmpty)
                    Text(
                      product.barannd!,
                      style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
