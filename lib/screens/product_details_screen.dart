import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/producty_model.dart';
import 'add_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductyModel productyModel;

  const ProductDetailsScreen({super.key, required this.productyModel});

  void _showOptions(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddProductScreen(productyModel: productyModel),
                ),
              );
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Color(0xFF007AFF),
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              final shouldDelete = await showCupertinoDialog<bool>(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                  title: const Text('Delete product'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                await GetIt.I.get<Box<ProductyModel>>().delete(id);
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFFF3B30),
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF007AFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.I.get<Box<ProductyModel>>().listenable(),
      builder: (context, Box<ProductyModel> box, _) {
        final product = box.get(productyModel.id);

        if (product == null) {
          return const Center(child: Text('Product not found'));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              product.isInWishlist ? 'Wish product' : 'Product',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset('assets/icons/back.svg'),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => _showOptions(context, product.id),
                child: SvgPicture.asset('assets/icons/dots.svg'),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child:
                        product.phottooo != null && product.phottooo!.isNotEmpty
                            ? Image.file(
                                File(product.phottooo!),
                                width: double.infinity,
                                height: 220.h,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.png',
                                width: double.infinity,
                                height: 220.h,
                                fit: BoxFit.cover,
                              ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: const Color(0xFF939393),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.nameee,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if ((product.barannd ?? '').isNotEmpty)
                    Text(
                      product.barannd!,
                      style: TextStyle(
                        color: const Color(0xFF3DC6FF),
                        fontSize: 12.sp,
                      ),
                    ),
                  if ((product.link ?? '').isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Link',
                                  style: TextStyle(
                                    color: const Color(0xFF939393),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: product.link!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Link copied to clipboard')),
                                    );
                                  },
                                  child: Text(
                                    'Copy',
                                    style: TextStyle(
                                      color: const Color(0xFF3DC6FF),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              product.link!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  if ((product.stars ?? '').isNotEmpty)
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < int.tryParse(product.stars!)!
                              ? Colors.amber
                              : Colors.grey.shade300,
                          size: 28.sp,
                        );
                      }),
                    ),
                  SizedBox(height: 16.h),
                  if ((product.commeeent ?? '').isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commentary',
                            style: TextStyle(
                              color: const Color(0xFF939393),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            product.commeeent!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: product.isInWishlist
              ? GestureDetector(
                  onTap: () async {
                    final box = GetIt.I.get<Box<ProductyModel>>();
                    await box.put(
                      product.id,
                      product.copyWith(
                        isInWishlist: false,
                        link: '',
                        stars: '0',
                      ),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 54.h,
                    margin: EdgeInsets.symmetric(horizontal: 55.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      color: const Color(0xFF3DC6FF),
                    ),
                    child: Text(
                      'Bought',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
