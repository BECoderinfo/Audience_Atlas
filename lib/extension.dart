

import 'package:audience_atlas/utils/import.dart';

extension ContextSize on BuildContext {
  double get h => MediaQuery.of(this).size.height;

  double get w => MediaQuery.of(this).size.width;

  double get pT => MediaQuery.of(this).padding.top;

  double get pB => MediaQuery.of(this).padding.bottom;

  unFocus() {
    FocusScope.of(this).unfocus();
  }
}

extension PaddingExt on num {
  EdgeInsets get pAll => EdgeInsets.all(toDouble());

  EdgeInsets get mAll => EdgeInsets.all(toDouble());

  BorderRadius get rAll => BorderRadius.circular(toDouble());

  SizedBox get vs => SizedBox(
        height: toDouble(),
      );

  SizedBox get hs => SizedBox(
        width: toDouble(),
      );
}

extension NavigationExtension on String {
  dynamic toNamed({
    VoidCallback? onTap,
  }) {
    Get.toNamed(this)?.then(
      (value) {
        return value;
      },
    );
  }

  // offNamed({
  //   VoidCallback? onTap,
  // }) {
  //   Get.offNamed(this)?.then(
  //     (value) {
  //       if (onTap != null) {
  //         onTap();
  //       }
  //     },
  //   );
  // }

  offAllNamed({
    VoidCallback? onTap,
  }) {
    Get.offAllNamed(this)?.then(
      (value) {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }

  bool get isValidEmail =>
      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(this);

  bool get isValidPhone => !RegExp(r'^\d{10}$').hasMatch(this);

  bool get isValidBloodGroup =>
      !["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].contains(this);

  String formatTimeString() {
    final match = RegExp(r"(\d{1,2}):(\d{2})\s*(AM|PM)", caseSensitive: false)
        .firstMatch(this);

    if (match == null) {
      throw FormatException("Invalid time format: $this");
    }

    return "${match.group(1)!}:${match.group(2)!} ${match.group(3)!.toUpperCase()}";
  }

  TimeOfDay stringToTimeOfDay() {
    final match = RegExp(r"(\d{1,2}):(\d{2})\s*(AM|PM)", caseSensitive: false)
        .firstMatch(this);

    if (match == null) {
      throw FormatException("Invalid time format: $this");
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String meridiem = match.group(3)!.toUpperCase();

    if (meridiem == "PM" && hour != 12) {
      hour += 12;
    } else if (meridiem == "AM" && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
