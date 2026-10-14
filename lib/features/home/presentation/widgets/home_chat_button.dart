import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/contact_launcher.dart';

/// Floating contact button: tapping it unfolds a column of the store's
/// social / contact links above it.
class HomeChatButton extends StatefulWidget {
  const HomeChatButton({super.key});

  @override
  State<HomeChatButton> createState() => _HomeChatButtonState();
}

class _HomeChatButtonState extends State<HomeChatButton> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.primaryColor.withValues(alpha: 0.6);
    Widget fa(FaIconData icon) =>
        FaIcon(icon, size: 26.sp, color: Colors.white);

    final actions = <_ContactBubble>[
      _ContactBubble(
        icon: fa(FontAwesomeIcons.instagram),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFFEDA75), Color(0xFFD62976), Color(0xFF4F5BD5)],
        ),
        onTap: () => openExternalUrl(context, instagramUrl),
      ),
      _ContactBubble(
        icon: fa(FontAwesomeIcons.tiktok),
        color: Colors.black,
        onTap: () => openExternalUrl(context, tiktokUrl),
      ),
      _ContactBubble(
        icon: fa(FontAwesomeIcons.snapchat),
        color: const Color(0xFFFFFC00),
        onTap: () => openExternalUrl(context, snapchatUrl),
      ),
      _ContactBubble(
        icon: fa(FontAwesomeIcons.whatsapp),
        color: const Color(0xFF25D366),
        onTap: () => openWhatsApp(context),
      ),
      _ContactBubble(
        icon: Icon(Icons.phone_outlined, size: 28.sp, color: Colors.white),
        color: tint,
        onTap: callContactPhone,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < actions.length; i++)
          // Unfold bottom-up: the button nearest the toggle appears first.
          AnimatedScale(
            scale: _open ? 1 : 0,
            duration: Duration(milliseconds: 150 + (actions.length - i) * 40),
            curve: Curves.easeOutBack,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _open
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: actions[i],
                    )
                  : const SizedBox(width: 0),
            ),
          ),
        _ContactBubble(
          icon: Icon(
            _open ? Icons.close_rounded : Icons.forum_outlined,
            size: 28.sp,
            color: Colors.white,
          ),
          color: tint,
          onTap: () => setState(() => _open = !_open),
        ),
      ],
    );
  }
}

class _ContactBubble extends StatelessWidget {
  const _ContactBubble({
    required this.icon,
    required this.onTap,
    this.color,
    this.gradient,
  });

  final Widget icon;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          gradient: gradient,
          boxShadow: AppShadows.card(context),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
