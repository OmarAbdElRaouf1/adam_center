import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/categories_sidebar_layout.dart';
import 'package:the_one_test/features/home/presentation/widgets/floating_header_layout.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

import '../../../../core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
      child: StoreScaffold(
        key: ValueKey(context.locale.languageCode),
        currentTab: HomeTab.categories,
        body: FloatingHeaderLayout(
          header: const StoreHeader(),
          bodyBuilder: (context, topInset) => StorePullToRefresh(
            topInset: topInset,
            onRefresh: () {
              final bloc = context.read<CategoryBloc>()
                ..add(const GetMainCategoriesEvent());
              return untilLoaded(bloc);
            },
            builder: (controller) => CategoriesSidebarLayout(
              topInset: topInset,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
