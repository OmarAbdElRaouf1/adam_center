import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/categories_sidebar_layout.dart';

import '../../../../core/helper/helper.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
      child: Scaffold(
        key: ValueKey(context.locale.languageCode),
        appBar: const CustomAppBar(titleText: 'Categories'),
        body: SafeArea(
          child: Column(
            children: [
              Gap(20.h),
              const Expanded(child: CategoriesSidebarLayout()),
            ],
          ),
        ),
      ),
    );
  }
}
