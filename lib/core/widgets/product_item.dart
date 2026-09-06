// import 'package:easy_localization/easy_localization.dart';
// import '../../../../../../../core/helper/helper.dart';

// import '../models/item_model.dart';
// import 'product_item/widgets/advanced_counter_box.dart';
// import 'product_item/widgets/favorite_button.dart';
// import 'product_item/widgets/product_labels.dart';

// class EnhancedProductItem extends StatefulWidget {
//   const EnhancedProductItem({
//     super.key,
//     required this.product,
//     this.initialIsFavorite = false,
//     this.initialIsInCart = false,
//     this.initialQuantity = 1,
//     this.fallbackImage,
//     this.allowOutOfStock = false,
//   });

//   final ItemModel product;
//   final bool initialIsFavorite;
//   final bool initialIsInCart;
//   final int initialQuantity;
//   final String? fallbackImage;
//   final bool allowOutOfStock;

//   @override
//   State<EnhancedProductItem> createState() => _EnhancedProductItemState();
// }

// class _EnhancedProductItemState extends State<EnhancedProductItem> {
//   late bool _isFavorite;
//   late bool _isInCart;
//   late int _quantity;
//   bool _isIncrementing = false;
//   bool _isDecrementing = false;

//   @override
//   void initState() {
//     super.initState();
//     _isFavorite = widget.initialIsFavorite;
//     _isInCart = widget.initialIsInCart;
//     _quantity = widget.initialQuantity;
//     _isIncrementing = false;
//     _isDecrementing = false;
//   }

//   BasketItemModel _buildBasketItem(int salesQuantity) {
//     final customerModel = getIt<IUserCache>().getUserModel();
//     return BasketItemModel(
//       customerID: customerModel?.customerId ?? 0,
//       customerName: '',
//       customerEName: '',
//       productID: widget.product.productId,
//       productCode: widget.product.barCode,
//       productName: widget.product.productArName,
//       productEnName: widget.product.productEnName,
//       salesQuantity: salesQuantity,
//       barCode: widget.product.barCode,
//       customerPhone: '',
//       specifications: '',
//       discountPercent: _discountPercent,
//       productImage: widget.product.productImage ?? '',
//       stockQuantity: widget.product.stockQuantity.toDouble(),
//       price: widget.product.price,
//       customerQuantity: widget.product.customerQuantity ?? 0,
//       totalQuantity: 0,
//       requiredQTY: 0,
//       giftQTY: 0,
//       yGiftQty: 0,
//       categoryId: 0,
//       priceBeforeDiscount: widget.product.price,
//       priceAfterDiscount: widget.product.priceAfterDiscount,
//     );
//   }

//   void _toggleFavorite() {
//     final previousFavoriteState = _isFavorite;
//     setState(() {
//       _isFavorite = !_isFavorite;
//     });

//     final customerModel = getIt<IUserCache>().getUserModel();
//     if (customerModel == null) {
//       if (mounted) {
//         showCustomSnackBar(context, 'please_log_in_to_manage_favorites'.tr());
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const RegisterScreen()),
//         );
//       }
//       setState(() {
//         _isFavorite = previousFavoriteState;
//       });
//       return;
//     }

//     if (_isFavorite) {
//       context.read<FavoriteBloc>().add(
//         AddFavorite(
//           AddAndDeleteFavoriteRequest(
//             productID: widget.product.productId,
//             customerPhone: customerModel.customerPhone!,
//             barCode: widget.product.productCode,
//           ),
//         ),
//       );
//     } else {
//       context.read<FavoriteBloc>().add(
//         DeleteFavorite(
//           AddAndDeleteFavoriteRequest(
//             productID: widget.product.productId,
//             customerPhone: customerModel.customerPhone!,
//             barCode: widget.product.productCode,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _addToCart() async {
//     if (widget.product.isOutOfStock && !widget.allowOutOfStock) {
//       if (mounted) {
//         showCustomSnackBar(context, 'product_currently_unavailable'.tr());
//       }
//       return;
//     }

//     final customerModel = getIt<IUserCache>().getUserModel();
//     if (customerModel == null) {
//       if (mounted) {
//         showCustomSnackBar(context, 'please_log_in_to_add_to_cart'.tr());
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const RegisterScreen()),
//         );
//       }
//       return;
//     }

//     setState(() {
//       _isIncrementing = true;
//       _isInCart = true;
//       _quantity++;
//     });

//     final request = AddToBasketRequest(
//       customerID: customerModel.customerId,
//       productID: widget.product.productId,
//       productBarcode: widget.product.barCode,
//     );
//     context.read<AddToBasketBloc>().add(AddToBasket(request));
//     context.read<BasketBloc>().add(
//       UpsertBasketItem(_buildBasketItem(_quantity)),
//     );
//   }

//   Future<void> _incrementQuantity() async {
//     final customerModel = getIt<IUserCache>().getUserModel();
//     if (customerModel == null) return;

//     final stockQuantity = widget.product.stockQuantity;

//     if (stockQuantity > 0 && _quantity >= stockQuantity) {
//       if (mounted) {
//         showCustomSnackBar(context, 'max_quantity_reached'.tr());
//       }
//       return;
//     }

//     if (_quantity >= 10) {
//       await _showQuantityDialog(isFromDecrement: false);
//     } else {
//       setState(() {
//         _isIncrementing = true;
//         _quantity++;
//       });

//       if (context.mounted) {
//         context.read<AddToBasketBloc>().add(
//           AddToBasket(
//             AddToBasketRequest(
//               customerID: customerModel.customerId,
//               productID: widget.product.productId,
//               productBarcode: widget.product.barCode,
//             ),
//           ),
//         );
//         context.read<BasketBloc>().add(
//           UpsertBasketItem(_buildBasketItem(_quantity)),
//         );
//       }
//     }
//   }

//   Future<void> _decrementQuantity() async {
//     final customerModel = getIt<IUserCache>().getUserModel();
//     if (customerModel == null) {
//       if (mounted) {
//         showCustomSnackBar(context, 'please_log_in_to_manage_cart'.tr());
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const RegisterScreen()),
//         );
//       }
//       return;
//     }

//     if (_quantity > 15) {
//       await _showQuantityDialog(isFromDecrement: true);
//     } else {
//       setState(() {
//         _isDecrementing = true;
//         _quantity--;
//       });
//       context.read<BasketBloc>().add(
//         DeleteBasketItem(widget.product.productId, widget.product.barCode),
//       );
//     }
//   }

//   bool get _hasDiscount =>
//       widget.product.price != widget.product.priceAfterDiscount;

//   bool get _canAddToCart {
//     if (widget.allowOutOfStock) return true;
//     if (widget.product.isOutOfStock) return false;
//     return _quantity < widget.product.stockQuantity;
//   }

//   int get _discountPercent {
//     if (widget.product.price <= 0) return 0;
//     return (((widget.product.price - widget.product.priceAfterDiscount) /
//                 widget.product.price) *
//             100)
//         .round();
//   }

//   double _itemWidth(BuildContext context) {
//     final screenWidth = context.screenWidth;
//     final isTablet = screenWidth >= 600;
//     return screenWidth * (isTablet ? 0.28 : 0.4);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDarkMode;
//     final isArabic = context.locale.languageCode == 'ar';
//     final productName = isArabic
//         ? widget.product.productArName
//         : widget.product.productEnName;
//     final currency = 'EGP'.tr();

//     return MultiBlocListener(
//       listeners: [
//         BlocListener<BasketBloc, BaseState<BasketItemModel>>(
//           listener: (context, state) {
//             if (state.metadata['productId'] != widget.product.productId) {
//               return;
//             }
//             if (state.status == Status.success ||
//                 state.status == Status.failure) {
//               if (mounted) setState(() => _isDecrementing = false);
//             }
//           },
//         ),
//         BlocListener<AddToBasketBloc, BaseState<void>>(
//           listener: (context, state) {
//             if (state.metadata['productId'] != widget.product.productId) {
//               return;
//             }
//             if (state.status == Status.success ||
//                 state.status == Status.failure) {
//               if (mounted) setState(() => _isIncrementing = false);
//             }
//           },
//         ),
//       ],
//       child: BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
//         builder: (context, basketState) {
//           final basketItems = basketState.items.where(
//             (item) => item.productID == widget.product.productId,
//           );
//           final quantityFromBasket = basketItems.isNotEmpty
//               ? basketItems.first.salesQuantity
//               : 0;
//           _quantity = quantityFromBasket;

//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MultiBlocProvider(
//                     providers: [
//                       BlocProvider.value(value: getIt<AddToBasketBloc>()),
//                       BlocProvider.value(value: getIt<BasketBloc>()),
//                       BlocProvider(
//                         create: (context) => getIt<ProductDetailsBloc>(),
//                       ),
//                       BlocProvider(
//                         create: (context) => getIt<SubCategoryProductBloc>(),
//                       ),
//                     ],
//                     child: DetailsScreen(
//                       productId: widget.product.productId,
//                       initialQuantity: _quantity,
//                       stockQuantity: widget.product.stockQuantity.toDouble(),
//                       allowOutOfStock: widget.allowOutOfStock,
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               width: _itemWidth(context),
//               decoration: BoxDecoration(
//                 color: isDark ? AppColors.codGray : Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.white12 : Colors.grey.shade200,
//                 ),
//                 boxShadow: isDark
//                     ? []
//                     : [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.06),
//                           blurRadius: 14,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//               ),
//               child: Stack(
//                 children: [
//                   Opacity(
//                     opacity: (widget.product.isOutOfStock && !widget.allowOutOfStock) ? 0.5 : 1.0,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Image + badges ────────────────────────────
//                         Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(16),
//                               ),
//                               child: Container(
//                                 color: isDark
//                                     ? Colors.white.withValues(alpha: 0.04)
//                                     : Colors.grey.shade50,
//                                 child: FlexibleImage(
//                                   source: widget.product.productImage ?? '',
//                                   fallbackImage: widget.fallbackImage,
//                                   height: 132,
//                                   width: double.infinity,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                             if (_hasDiscount)
//                               Positioned(
//                                 top: 0,
//                                 right: 0,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 6.w,
//                                     vertical: 3.h,
//                                   ),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(16),
//                                       bottomLeft: Radius.circular(8),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     '-$_discountPercent%',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 9.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             FavoriteButton(
//                               isFavorite: _isFavorite,
//                               onTap: _toggleFavorite,
//                             ),
//                           ],
//                         ),

//                         // ── Info section ──────────────────────────────
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               FittedBox(
//                                 child: Text(
//                                   productName,
//                                  // maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: AppTextTheme.bodySmall.copyWith(
//                                     color: isDark
//                                         ? Colors.white
//                                         : AppColors.black,
//                                     fontSize: 11.5.sp,
//                                     fontWeight: FontWeight.w600,
//                                     height: 1.3,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 6.h),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                                 textBaseline: TextBaseline.alphabetic,
//                                 children: [
//                                   Text(
//                                     '${widget.product.priceAfterDiscount.toStringAsFixed(2)} $currency',
//                                     style: TextStyle(
//                                       color: isDark
//                                           ? Colors.white
//                                           : AppColors.mainAppColor,
//                                       fontSize: 13.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   if (_hasDiscount) ...[
//                                     SizedBox(width: 5.w),
//                                     Text(
//                                       '${widget.product.price.toStringAsFixed(2)} $currency',
//                                       style: TextStyle(
//                                         color: isDark
//                                             ? Colors.white38
//                                             : Colors.grey,
//                                         fontSize: 9.sp,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                               SizedBox(height: 4.h),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   AdvancedCounterBox(
//                                     quantity: _quantity,
//                                     isIncrementing: _isIncrementing,
//                                     isDecrementing: _isDecrementing,
//                                     canAddToCart: _canAddToCart,
//                                     onDecrement: _decrementQuantity,
//                                     onIncrement: _incrementQuantity,
//                                     onAddToCart: _addToCart,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (widget.product.isOutOfStock && !widget.allowOutOfStock)
//                     const OutOfStockBanner(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _showQuantityDialog({required bool isFromDecrement}) async {
//     final title = isFromDecrement
//         ? 'Quantity is high. Enter the desired total quantity'.tr()
//         : 'Quantity is getting high. Enter the desired total quantity:'.tr();

//     final result = await showDialog<String>(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         final controller = TextEditingController();
//         return AlertDialog(
//           backgroundColor: AppColors.backgroundColor,
//           title: Text(title, style: AppTextTheme.bodySmall),
//           content: TextField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hintText: 'Total number of items'.tr(),
//               hintStyle: AppTextTheme.captionBold,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: Text('Cancel'.tr()),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext, controller.text),
//               child: Text('Set'.tr()),
//             ),
//           ],
//         );
//       },
//     );

//     if (result != null) {
//       final newTotal = int.tryParse(result) ?? -1;
//       if (newTotal >= 0) {
//         final customerModel = getIt<IUserCache>().getUserModel();
//         if (customerModel == null) return;

//         final diff = newTotal - _quantity;

//         // Handle both increasing and decreasing
//         if (diff != 0) {
//           final isIncreasing = diff > 0;
//           final iterations = diff.abs();

//           setState(() {
//             if (isIncreasing) {
//               _isIncrementing = true;
//             } else {
//               _isDecrementing = true;
//             }
//           });

//           for (int i = 0; i < iterations; i++) {
//             if (isIncreasing) {
//               // Adding to basket
//               final stockQuantity = widget.product.stockQuantity;
//               if (stockQuantity > 0 && _quantity >= stockQuantity) {
//                 if (mounted) {
//                   showCustomSnackBar(context, 'max_quantity_reached'.tr());
//                 }
//                 break;
//               }

//               if (mounted) {
//                 context.read<AddToBasketBloc>().add(
//                   AddToBasket(
//                     AddToBasketRequest(
//                       customerID: customerModel.customerId,
//                       productID: widget.product.productId,
//                       productBarcode: widget.product.barCode,
//                     ),
//                   ),
//                 );
//               }
//               _quantity++;
//               _isInCart = true;
//             } else {
//               // Removing from basket
//               if (mounted) {
//                 context.read<BasketBloc>().add(
//                   DeleteBasketItem(
//                     widget.product.productId,
//                     widget.product.barCode,
//                   ),
//                 );
//               }
//               _quantity--;
//             }
//           }
//           setState(() {});
//           if (isIncreasing && mounted) {
//             context.read<BasketBloc>().add(
//               UpsertBasketItem(_buildBasketItem(_quantity)),
//             );
//           }
//         }
//       }
//     }
//   }
// }
