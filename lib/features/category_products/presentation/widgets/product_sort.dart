import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

enum ProductSort {
  newest('Newest'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low');

  const ProductSort(this.labelKey);

  final String labelKey;

  /// Sorts the product maps built by `toProductMap()` — client side, since
  /// the product endpoints have no sort parameter.
  List<Map<String, String>> apply(List<Map<String, String>> products) {
    double priceOf(Map<String, String> p) {
      final price = double.tryParse(p['price'] ?? '') ?? 0;
      final discounted = double.tryParse(p['priceAfterDiscount'] ?? '') ?? 0;
      return discounted > 0 && discounted < price ? discounted : price;
    }

    final sorted = [...products];
    switch (this) {
      case ProductSort.newest:
        sorted.sort((a, b) {
          final aDate = DateTime.tryParse(a['date'] ?? '');
          final bDate = DateTime.tryParse(b['date'] ?? '');
          if (aDate != null && bDate != null) return bDate.compareTo(aDate);
          // No usable registration date — newer products get higher ids.
          final aId = int.tryParse(a['id'] ?? '') ?? 0;
          final bId = int.tryParse(b['id'] ?? '') ?? 0;
          return bId.compareTo(aId);
        });
      case ProductSort.priceLowToHigh:
        sorted.sort((a, b) => priceOf(a).compareTo(priceOf(b)));
      case ProductSort.priceHighToLow:
        sorted.sort((a, b) => priceOf(b).compareTo(priceOf(a)));
    }
    return sorted;
  }
}

Future<void> showProductSortSheet(
  BuildContext context, {
  required ProductSort current,
  required ValueChanged<ProductSort> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By'.tr(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            Gap(8.h),
            for (final sort in ProductSort.values)
              ListTile(
                title: Text(sort.labelKey.tr()),
                trailing: sort == current
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onSelected(sort);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

/// White rounded field showing the current sort, like a dropdown.
class ProductSortField extends StatelessWidget {
  const ProductSortField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProductSort value;
  final ValueChanged<ProductSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.chip.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.chip.r),
          onTap: () => showProductSortSheet(
            context,
            current: value,
            onSelected: onChanged,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.labelKey.tr(),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppColors.primaryColor,
                  size: 28.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
