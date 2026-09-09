import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/datasource/place_order_datasource.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/manager/add_address_bloc/add_address_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/manager/choose_address_bloc/choose_address_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/manager/payment_bloc/payment_bloc.dart';

// Bloc-vs-Cubit rule for this app: a manager becomes a Bloc+Event when it
// runs a full network-driven CRUD flow shaped like auth's blocs (fetch/
// mutate -> emit loading/success/failure against a datasource) — PaymentBloc,
// AddAddressCubit and ChooseAddressBloc below all fit that shape. A manager
// with no such flow (pure UI state, or no injected dependency to justify DI)
// stays a Cubit — e.g. AccountCubit, CategorySelectionCubit, NavBarCubit,
// InfoImagesCubit. ChangePasswordCubit is DI-registered (see
// AccountServiceLocator) and does a single loading/success/failure submit
// against a datasource, but stays a Cubit rather than Bloc+Event since it's
// a one-shot action, not a multi-event flow.
class CheckoutServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<PlaceOrderDatasource>(
      () => PlaceOrderDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
        getIt<AddToCartDataSource>(),
      ),
    );
    getIt.registerLazySingleton<AddAddressDatasource>(
      () => AddAddressDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );
    getIt.registerFactory<ChooseAddressBloc>(
      () => ChooseAddressBloc(
        getIt<AddAddressDatasource>(),
        getIt<AccountCubit>(),
      ),
    );
    getIt.registerFactory<AddAddressBloc>(
      () =>
          AddAddressBloc(getIt<AddAddressDatasource>(), getIt<AccountCubit>()),
    );

    // Factory-with-param since PaymentBloc needs runtime subtotal +
    // deliveryInfo (carried from the cart/checkout flow into the view).
    getIt.registerFactoryParam<PaymentBloc, double, DeliveryInfoModel>(
      (subtotal, deliveryInfo) => PaymentBloc(
        getIt<PlaceOrderDatasource>(),
        subtotal: subtotal,
        deliveryInfo: deliveryInfo,
      ),
    );
  }
}
