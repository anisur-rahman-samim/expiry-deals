import 'package:expiry_deals/app/modules/home/controllers/deals_list_controller.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart' as allProduct;
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-screen paginated list for a discount band or sort (See all from home).
class DealsListView extends StatefulWidget {
  const DealsListView({
    super.key,
    required this.title,
    this.minDiscount,
    this.maxDiscount,
    this.expiringWithinHours,
    this.sort,
  });

  final String title;
  final double? minDiscount;
  final double? maxDiscount;
  final int? expiringWithinHours;
  final String? sort;

  @override
  State<DealsListView> createState() => _DealsListViewState();
}

class _DealsListViewState extends State<DealsListView> {
  late final String _tag;
  late final DealsListController controller;
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _tag = 'deals_${DateTime.now().microsecondsSinceEpoch}';
    controller = Get.put(
      DealsListController(
        minDiscount: widget.minDiscount,
        maxDiscount: widget.maxDiscount,
        expiringWithinHours: widget.expiringWithinHours,
        sort: widget.sort,
      ),
      tag: _tag,
    );
    _scroll = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    final pos = _scroll.position;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    if (Get.isRegistered<DealsListController>(tag: _tag)) {
      Get.delete<DealsListController>(tag: _tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }
        if (controller.products.isEmpty) {
          return Center(
            child: Text(
              'No products in this list yet.',
              style: h4.copyWith(color: AppColors.hintColor),
            ),
          );
        }
        return ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length +
              (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.products.length) {
              return Obx(() {
                if (!controller.isLoadingMore.value) {
                  return const SizedBox(height: 24);
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                      strokeWidth: 2,
                    ),
                  ),
                );
              });
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DealRowCard(product: controller.products[index]),
            );
          },
        );
      }),
    );
  }
}

class _DealRowCard extends StatelessWidget {
  const _DealRowCard({required this.product});

  final allProduct.Products product;

  @override
  Widget build(BuildContext context) {
    final img = product.images.isNotEmpty
        ? (product.images.first.url ?? AppImages.noImage)
        : AppImages.noImage;
    final price = product.price is num
        ? (product.price as num).toDouble()
        : 0.0;
    final disc = product.discount is num
        ? (product.discount as num).toDouble()
        : 0.0;
    final sale = price * (1 - disc / 100);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(
          () => ProductDetailsView(productId: product.id ?? ''),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 88,
                    height: 88,
                    color: AppColors.grayLight,
                    child: Icon(Icons.image_outlined, color: AppColors.hintColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: h3.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    sw5,
                    Text(
                      product.author?.shop?.name ?? '',
                      style: h5.copyWith(color: AppColors.hintColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${sale.toStringAsFixed(2)}',
                          style: h3.copyWith(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        sw5,
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: h4.copyWith(
                            color: AppColors.gray,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${disc.toStringAsFixed(0)}%',
                            style: GoogleFonts.dmSans(
                              color: AppColors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
