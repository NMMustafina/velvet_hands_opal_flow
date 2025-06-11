import 'package:hive/hive.dart';

part 'producty_model.g.dart';

@HiveType(typeId: 0)
class ProductyModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String nameee;

  @HiveField(3)
  final String? barannd;

  @HiveField(4)
  final String? stars;

  @HiveField(5)
  final String? commeeent;

  @HiveField(6)
  final String? phottooo;

  @HiveField(7)
  final bool isInWishlist;

  @HiveField(8)
  final String? link;

  ProductyModel({
    required this.id,
    required this.category,
    required this.nameee,
    this.barannd,
    this.stars,
    this.commeeent,
    this.phottooo,
    required this.isInWishlist,
    this.link,
  });

  ProductyModel copyWith({
    String? id,
    String? category,
    String? nameee,
    String? barannd,
    String? stars,
    String? commeeent,
    String? phottooo,
    bool? isInWishlist,
    String? link,
  }) {
    return ProductyModel(
      id: id ?? this.id,
      category: category ?? this.category,
      nameee: nameee ?? this.nameee,
      barannd: barannd ?? this.barannd,
      stars: stars ?? this.stars,
      commeeent: commeeent ?? this.commeeent,
      phottooo: phottooo ?? this.phottooo,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      link: link ?? this.link,
    );
  }
}
