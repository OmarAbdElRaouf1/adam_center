// import 'package:easy_localization/easy_localization.dart';
// import '../bloc/theme_bloc/theme_bloc.dart';

// import '../helper/helper.dart';
// import 'helping_screen.dart';
// import 'language_toggle_button.dart';

// class CustomAppDrawer extends StatelessWidget {
//   const CustomAppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ColoredBox(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(AppAssets.appLogoIbs, height: 100),
//             ),

//             // 66206215
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 children: [
//                   const Divider(height: 32, thickness: 1),
//                   LanguageDropdownSection(),
//                   const Divider(height: 32, thickness: 1),
//                   const ThemeDropdownSection(),
//                   const Divider(height: 32, thickness: 1),
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.home_outlined,
//                     title: "home_title".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => MultiBlocProvider(
//                       //       providers: [
//                       //         // BlocProvider.value(value: getIt<MainCategoryBloc>()),
//                       //         // BlocProvider.value(value: getIt<BestSellerBloc>()),
//                       //         // BlocProvider.value(value: getIt<BiggestDiscountBloc>()),
//                       //         // BlocProvider.value(value: getIt<NewProductBloc>()),
//                       //         // BlocProvider(
//                       //         //   create: (context) => getIt<CarouselBloc>()
//                       //         //     ..add(
//                       //         //       FetchCarouselItems([
//                       //         //         CarouselEnum.one,
//                       //         //         CarouselEnum.two,
//                       //         //         CarouselEnum.three,
//                       //         //       ]),
//                       //         //     ),
//                       //         // ),
//                       //       ],
//                       //       child: HomeScreenWidget(),
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.person_outline,
//                     title: "profile_title".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       if(getIt<IUserCache>().getUserModel()!.customerPhone == null ){
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>  LoginScreen(),
//                           ),
//                         );
//                       }else{
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ProfileScreen(),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   // favorites
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.favorite_border,
//                     title: "favorites".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       if (getIt<IUserCache>().getUserModel()?.customerPhone != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const FavouritesScreen(),
//                           ),
//                         );
//                       } else {
//                         Navigator.pop(context);
//                         showCustomSnackBar(context, 'please_log_in'.tr());
//                       }
//                     },
//                   ),
//                   // previous orders
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.shopping_cart_outlined,
//                     title: "my_previous_orders".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       if(getIt<IUserCache>().getUserModel()!.customerPhone != null ){
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>  BlocProvider.value(value:  getIt<PreviousOrdersBloc>(), child: MyPreviousOrders()),
//                           ),
//                         );
//                       }else{
//                         Navigator.pop(context);
//                         showCustomSnackBar(context, 'please_log_in'.tr());
//                       }
//                     },
//                   ),
//                   // offers screen
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.local_offer_outlined,
//                     title: "offers".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>  BlocProvider(create: (context) => getIt<OffersBloc>() , child: OffersScreen()),
//                           ),
//                         );
//                     },
//                   ),
//                   // whoWeAre
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.info_outline,
//                     title: "who_we_are".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BlocProvider(
//                               create: (context) => getIt<WhoWeAreBloc>(),
//                               child: const WhoWeAreScreen()),
//                         ),
//                       );
//                     },
//                   ),
//                   // policy and privacy
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.info_outline,
//                     title: "privacy_policy".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PrivacyPolicyScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   // return policy
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.assignment_return_outlined,
//                     title: "return_policy".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ReturnPolicyScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   // FrequentlyQuestion
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.info_outline,
//                     title: "frequently_questions".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  FrequentlyQuestion(),
//                         ),
//                       );
//                     },
//                   ),

//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.help_outline,
//                     title: "help_title".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HelpScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.info_outline,
//                     title: "about_title".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AboutAppScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     icon: Icons.logout_outlined,
//                     title: "log_out".tr(),
//                     iconColor: AppColors.mainAppColor,
//                     onTap: () {
//                       getIt<IUserCache>().clearUserModel();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  LoginScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.grey[600], size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Version 1.0.0",
//                     style: AppTextTheme.captionBold.copyWith(
//                       color: AppColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required Color iconColor,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//       leading: Icon(icon, color: iconColor, size: 24),
//       title: Text(
//         title,
//         style: AppTextTheme.body1.copyWith(color: AppColors.mainAppColor),
//       ),
//       onTap: onTap,
//     );
//   }
// }

// class ThemeDropdownSection extends StatelessWidget {
//   const ThemeDropdownSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         // Determine the effective brightness if it's currently system mode
//         final isDarkMode = state.themeMode == ThemeMode.system
//             ? MediaQuery.of(context).platformBrightness == Brightness.dark
//             : state.themeMode == ThemeMode.dark;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//           child: InkWell(
//             onTap: () {
//               // Toggle between light and dark
//               final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
//               context.read<ThemeBloc>().add(ThemeChanged(nextMode));
//             },
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? AppColors.codGray
//                     : Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? Colors.white12
//                       : Colors.grey.shade200,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                     color: isDarkMode ? Colors.yellow[700] : AppColors.mainAppColor,
//                     size: 24,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "theme_mode".tr(),
//                           style: AppTextTheme.body1.copyWith(
//                             color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.mainAppColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         if (state.themeMode == ThemeMode.system)
//                           Text(
//                             "system_default".tr(),
//                             style: AppTextTheme.bodySmall.copyWith(
//                               color: Colors.grey,
//                               fontSize: 10.sp,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   Transform.scale(
//                     scale: 0.8,
//                     child: Switch.adaptive(
//                       value: isDarkMode,
//                       activeThumbColor: Colors.yellow[700],
//                       onChanged: (bool value) {
//                         context.read<ThemeBloc>().add(ThemeChanged(value ? ThemeMode.dark : ThemeMode.light));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
