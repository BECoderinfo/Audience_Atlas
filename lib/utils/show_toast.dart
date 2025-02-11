import 'package:atlas_admin/extension.dart';

import 'import.dart';

class GFColors {
  static const Color SUCCESS = Color(0xff10DC60);
  static const Color DANGER = Color(0xffF04141);
  static const Color WHITE = Color(0xffffffff);
}

class ShowToast {
  // static Future<bool?> toast({required String msg}) async {
  //   return await Fluttertoast.showToast(msg: msg);
  // }

  static showSuccessGfToast({
    required String msg,
    required BuildContext ctx,
  }) {
    ToastView.dismiss();
    ToastView.createView(
      msg,
      ctx,
      2,
      GFColors.SUCCESS,
      const TextStyle(
        fontSize: 16,
        color: GFColors.WHITE,
      ),
      5.0,
    );
  }

  static showFailedGfToast({
    required String msg,
    required BuildContext ctx,
  }) {
    ToastView.dismiss();
    ToastView.createView(
      msg,
      ctx,
      2,
      GFColors.DANGER,
      const TextStyle(
        fontSize: 16,
        color: GFColors.WHITE,
      ),
      5.0,
    );
  }

  static void errorSnackBar({
    required String title,
    required String msg,
  }) {
    Get.snackbar(
      title,
      msg,
      margin: 10.mAll,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class ToastView {
  static OverlayState? overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void createView(
    String text,
    BuildContext context,
    int? toastDuration,
    Color backgroundColor,
    TextStyle textStyle,
    double toastBorderRadius,
  ) async {
    overlayState = Overlay.of(context, rootOverlay: false);

    final Widget toastChild = ToastCard(
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(toastBorderRadius),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(text, softWrap: true, style: textStyle),
        ),
        Duration(seconds: toastDuration ?? 2),
        fadeDuration: 500);

    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            Positioned(bottom: 60, left: 18, right: 18, child: toastChild));

    _isVisible = true;
    overlayState!.insert(_overlayEntry!);
    await Future.delayed(Duration(seconds: toastDuration ?? 2));
    await dismiss();
  }

  static Future<void> dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastCard extends StatefulWidget {
  const ToastCard(this.child, this.duration,
      {Key? key, this.fadeDuration = 500})
      : super(key: key);

  final Widget child;
  final Duration duration;
  final int fadeDuration;

  @override
  ToastStateFulState createState() => ToastStateFulState();
}

class ToastStateFulState extends State<ToastCard>
    with SingleTickerProviderStateMixin {
  void showAnimation() {
    _animationController!.forward();
  }

  void hideAnimation() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  AnimationController? _animationController;
  late Animation _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.fadeDuration),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showAnimation();
    _timer = Timer(widget.duration, hideAnimation);
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fadeAnimation as Animation<double>,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: widget.child,
          ),
        ),
      );
}
