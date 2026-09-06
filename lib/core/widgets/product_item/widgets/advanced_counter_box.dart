import '../../../../core/helper/helper.dart';

class AdvancedCounterBox extends StatelessWidget {
  final int quantity;
  final bool isIncrementing;
  final bool isDecrementing;
  final bool canAddToCart;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  const AdvancedCounterBox({
    super.key,
    required this.quantity,
    required this.isIncrementing,
    required this.isDecrementing,
    required this.canAddToCart,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  bool get isProcessing => isIncrementing || isDecrementing;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 29.h,
              padding: EdgeInsets.symmetric(horizontal: quantity > 0 ? 3.w : 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.isDarkMode ? AppColors.codGray : AppColors.white,
                    context.isDarkMode
                        ? AppColors.black.withValues(alpha: 0.3)
                        : AppColors.backgroundColor.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: context.isDarkMode
                      ? Colors.white24
                      : AppColors.mainAppColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainAppColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Remove Button
                  if (quantity > 0)
                    Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.codGray
                            : AppColors.mainAppColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(11.r),
                        border: Border.all(
                          color: context.isDarkMode
                              ? Colors.white38
                              : AppColors.mainAppColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(11.r),
                          onTap: isProcessing ? null : onDecrement,
                          child: Center(
                            child: isDecrementing
                                ? SizedBox(
                                    width: 11.w,
                                    height: 11.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        context.isDarkMode
                                            ? Colors.white
                                            : AppColors.mainAppColor,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.remove,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : AppColors.mainAppColor,
                                    size: 13.sp,
                                  ),
                          ),
                        ),
                      ),
                    ),

                  // Quantity Display
                  if (quantity > 0)
                    Container(
                      constraints: BoxConstraints(minWidth: 26.w),
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.mainAppColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Add Button
                  Opacity(
                    opacity: canAddToCart ? 1.0 : 0.4,
                    child: Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mainAppColor,
                            AppColors.tealAccentColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(11.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainAppColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(11.r),
                          onTap: (isProcessing || !canAddToCart)
                              ? null
                              : (quantity > 0 ? onIncrement : onAddToCart),
                          child: Center(
                            child: isIncrementing
                                ? SizedBox(
                                    width: 11.w,
                                    height: 11.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    quantity > 0
                                        ? Icons.add
                                        : Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: 13.sp,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
