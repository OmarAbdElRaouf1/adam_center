import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

extension ContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom != 0;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  static const _easternArabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Converts Western digits (0-9) in [value] to Eastern Arabic-Indic digits
  /// when the current locale is Arabic; returns [value] unchanged otherwise.
  String localizeDigits(String value) {
    if (!isArabic) return value;
    final buffer = StringBuffer();
    for (final char in value.split('')) {
      final digit = int.tryParse(char);
      buffer.write(digit == null ? char : _easternArabicDigits[digit]);
    }
    return buffer.toString();
  }

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
  TextDirection get oppositeTextDirection =>
      !isArabic ? TextDirection.rtl : TextDirection.ltr;

  FocusScopeNode get foucsScopeNode => FocusScope.of(this);

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        showCloseIcon: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                style: AppTextTheme.headlineMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(10.w),
            const Icon(Icons.error, color: Colors.red),
          ],
        ),
        backgroundColor: colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        margin: EdgeInsets.only(bottom: 25.h, right: 20.w, left: 20.w),
      ),
    );
  }

  void showSuccessMessage(
    String message, {
    Color color = Colors.green,
    IconData icon = Icons.check_circle,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          showCloseIcon: false,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message,

                  style: AppTextTheme.headlineMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(10.w),
              Icon(icon, color: color),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          margin: EdgeInsets.only(bottom: 25.h, right: 20.w, left: 20.w),
        ),
      );
    });
  }

  void showSuccessDialog(String text) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        content: Text(
          text,
          style: AppTextTheme.headlineMedium.copyWith(
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.all(20.w).copyWith(bottom: 40.h),
      ),
    );
  }

  void showTopSnackBar({
    required Widget child,
    required Color backgroundColor,
    IconData icon = Icons.error,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 16.w,
        right: 16.w,
        top: MediaQuery.of(context).padding.top + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                Gap(8.w),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(this).insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  void showLoadingDialog({
    String? message,
    bool canPop = false,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => PopScope(
        canPop: canPop,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              Gap(10.h),
              Text(
                message ?? " Loading...",
                style: theme.textTheme.titleLarge!,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          contentPadding: EdgeInsets.all(20.w).copyWith(bottom: 40.h),
        ),
      ),
    );
  }
}
