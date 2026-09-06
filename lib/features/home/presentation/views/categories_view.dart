import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/features/home/presentation/widgets/categories_sidebar_layout.dart';

import '../../../../core/helper/helper.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: ValueKey(context.locale.languageCode),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Categories'.tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Gap(20.h),
          const Expanded(child: CategoriesSidebarLayout()),
        ],
      ),
    );
  }
}
