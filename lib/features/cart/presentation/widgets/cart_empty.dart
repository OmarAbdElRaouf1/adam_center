import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'cart_header.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              const CartHeader(),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/cart_empty.svg',
                        width: context.screenWidth * 0.6,
                        height: context.screenHeight * 0.4,
                      ),

                      Gap(20.h),
                      Text(
                        'سلتك فارغة',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.heading1.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
