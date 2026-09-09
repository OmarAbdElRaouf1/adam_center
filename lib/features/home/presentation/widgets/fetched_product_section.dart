import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';

import '../../../category_products/data/models/item_model_x.dart';
import '../../../category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'home_product_section.dart';

class FetchedProductSection extends StatelessWidget {
  const FetchedProductSection({
    super.key,
    required this.title,
    required this.event,
    this.gap = 20,
  });

  final String title;
  final ProductEvent event;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(event),
      child: BlocBuilder<ProductBloc, BaseState<ItemModel>>(
        builder: (context, state) {
          return HomeProductSection(
            title: title,
            gap: gap,
            isLoading: state.isLoading,
            products: state.isLoading
                ? null
                : state.items.map((item) => item.toProductMap()).toList(),
          );
        },
      ),
    );
  }
}
