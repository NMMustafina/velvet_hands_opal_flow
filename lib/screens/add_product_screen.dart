import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../models/producty_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen(
      {super.key, this.productyModel, this.isWishlistMode = false});

  final ProductyModel? productyModel;
  final bool isWishlistMode;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int selectedRating = 0;
  String? selectedCategory;
  bool isFormValid = false;
  File? selectedImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  late String initialName;
  late String initialBrand;
  late String initialComment;
  late String initialLink;
  late String? initialCategory;
  late int initialRating;
  late String? initialPhotoPath;

  @override
  void initState() {
    super.initState();

    final model = widget.productyModel;

    initialCategory = model?.category;
    initialName = model?.nameee ?? '';
    initialBrand = model?.barannd ?? '';
    initialComment = model?.commeeent ?? '';
    initialLink = model?.link ?? '';
    initialRating = int.tryParse(model?.stars ?? '') ?? 0;
    initialPhotoPath = model?.phottooo;

    selectedCategory = initialCategory;
    selectedRating = initialRating;

    nameController.text = initialName;
    brandController.text = initialBrand;
    commentController.text = initialComment;
    linkController.text = initialLink;

    if (initialPhotoPath != null && initialPhotoPath!.isNotEmpty) {
      selectedImage = File(initialPhotoPath!);
    }

    nameController.addListener(_validateForm);
    brandController.addListener(_validateForm);
    commentController.addListener(_validateForm);
    linkController.addListener(_validateForm);

    _validateForm();
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    commentController.dispose();
    linkController.dispose();
    super.dispose();
  }

  bool _hasChanged() {
    return nameController.text != initialName ||
        brandController.text != initialBrand ||
        commentController.text != initialComment ||
        linkController.text != initialLink ||
        selectedCategory != initialCategory ||
        selectedRating != initialRating ||
        (selectedImage?.path ?? '') != (initialPhotoPath ?? '');
  }

  void _validateForm() {
    setState(() {
      isFormValid = selectedCategory != null &&
          selectedCategory!.isNotEmpty &&
          nameController.text.isNotEmpty &&
          _hasChanged();
    });
  }

  void _showPhotoPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final picked =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (picked != null) {
                setState(() {
                  selectedImage = File(picked.path);
                });
              }
            },
            child: const Text(
              'Media library',
              style: TextStyle(
                color: Color(0xFF007AFF),
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final picked =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) {
                setState(() {
                  selectedImage = File(picked.path);
                });
              }
            },
            child: const Text(
              'Camera',
              style: TextStyle(
                color: Color(0xFF007AFF),
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

  void _onSave() async {
    if (isFormValid) {
      try {
        final proid =
            widget.productyModel?.id ?? DateTime.now().toIso8601String();

        final isWish =
            widget.productyModel?.isInWishlist ?? widget.isWishlistMode;

        final addIncc = ProductyModel(
          id: proid,
          category: selectedCategory!,
          nameee: nameController.text,
          barannd: brandController.text,
          stars: isWish ? null : selectedRating.toString(),
          commeeent: commentController.text,
          phottooo: selectedImage?.path,
          isInWishlist: isWish,
          link: isWish ? linkController.text : '',
        );

        final box = GetIt.I.get<Box<ProductyModel>>();
        await box.put(proid, addIncc);

        Navigator.pop(context, addIncc);
      } catch (e) {
        print('Error saving product: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            final leave = await _showLeaveConfirmation();
            if (leave && mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Center(child: SvgPicture.asset('assets/icons/back.svg')),
        ),
        title: Text(
          widget.productyModel != null
              ? (widget.productyModel!.isInWishlist
                  ? 'Edit wish product'
                  : 'Edit product')
              : widget.isWishlistMode
                  ? 'Add wish product'
                  : 'Add product',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category', isRequired: true),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => _buildCategorySelector(),
                  );

                  if (result != null) {
                    setState(() {
                      selectedCategory = result;
                    });
                    _validateForm();
                  }
                },
                child: _buildBoxWithArrow(
                    selectedCategory ?? 'Select a care product category'),
              ),
              SizedBox(height: 12.h),
              _buildLabel('Name', isRequired: true),
              SizedBox(height: 4.h),
              _buildInputField('Enter the name of the care product',
                  controller: nameController),
              SizedBox(height: 12.h),
              _buildLabel('Brand'),
              _buildInputField('Enter brand name of care products',
                  controller: brandController),
              if (widget.isWishlistMode ||
                  (widget.productyModel?.isInWishlist ?? false)) ...[
                SizedBox(height: 12.h),
                _buildLabel('Link'),
                _buildInputField('Store link', controller: linkController),
              ] else ...[
                SizedBox(height: 20.h),
                _buildRating(),
              ],
              SizedBox(height: 20.h),
              _buildLabel('Commentary'),
              SizedBox(height: 4.h),
              _buildInputField('More info',
                  maxLines: 5, controller: commentController),
              SizedBox(height: 16.h),
              _buildLabel('Photo'),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: _showPhotoPicker,
                child: _buildPhotoUpload(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: isFormValid ? _onSave : null,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 54.h,
          margin: EdgeInsets.symmetric(horizontal: 55.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            color: isFormValid
                ? const Color(0xFF3DC6FF)
                : const Color(0xFF3DC6FF).withOpacity(0.6),
          ),
          child: Text(
            widget.productyModel != null ? 'Save' : 'Add',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint,
      {int maxLines = 1,
      void Function(String)? onChanged,
      TextEditingController? controller}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.black,
      ),
      maxLines: maxLines,
      cursorColor: const Color(0xFF3DC6FF),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        hintStyle: TextStyle(color: const Color(0xFF939393), fontSize: 16.sp),
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Text.rich(
      TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFF939393),
          fontSize: 12.sp,
        ),
        children: isRequired
            ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
            : [],
      ),
    );
  }

  Widget _buildBoxWithArrow(String placeholder) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xFFF6F6F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            placeholder,
            style: TextStyle(
              color: placeholder == 'Select a care product category'
                  ? const Color(0xFF939393)
                  : Colors.black,
              fontSize: 16.sp,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF131313),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      {'label': 'Cream', 'icon': 'assets/icons/cream.svg'},
      {'label': 'Mask', 'icon': 'assets/icons/mask.svg'},
      {'label': 'Scrub', 'icon': 'assets/icons/scrub.svg'},
      {'label': 'Milk', 'icon': 'assets/icons/milk.svg'},
      {'label': 'Other', 'icon': 'assets/icons/other.svg'},
    ];

    return Container(
      padding:
          EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF3DC6FF), fontSize: 16.sp),
                ),
              ),
              Text(
                'Select category',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              ),
              SizedBox(width: 50.w),
            ],
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, cat['label']);
                },
                child: Container(
                  width: 164.w,
                  height: 162.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(cat['icon'] as String),
                      SizedBox(height: 8.h),
                      Text(
                        cat['label'] as String,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(8.r),
      color: Colors.grey,
      dashPattern: const [6, 4],
      strokeWidth: 1,
      child: Container(
        width: 164.w,
        height: 122.w,
        alignment: Alignment.center,
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  selectedImage!,
                  width: 164.w,
                  height: 122.w,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.photo_camera_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color:
                selectedRating > index ? Colors.amber : const Color(0xFFC9C9C9),
            size: 48.w,
          ),
          onPressed: () {
            setState(() {
              selectedRating = index + 1;
            });
          },
        );
      }),
    );
  }

  Future<bool> _showLeaveConfirmation() async {
    final hasChanged = nameController.text != initialName ||
        brandController.text != initialBrand ||
        commentController.text != initialComment ||
        linkController.text != initialLink ||
        selectedCategory != initialCategory ||
        selectedRating != initialRating ||
        (selectedImage?.path ?? '') != (initialPhotoPath ?? '');

    if (!hasChanged) return true;

    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(
          widget.productyModel != null ? 'Exit editing' : 'Leave the page',
        ),
        content: Text(
          widget.productyModel != null
              ? 'If you leave this page, changes to the product will not be saved.'
              : 'Are you sure you want to get out? This product will not be added.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            child: Text(
              widget.productyModel != null ? 'Exit' : 'Leave',
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
