import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mydukaanapp2/utils/app_colors.dart';

class Helpers {
  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.headerColor,
      textColor: Colors.white,
    );
  }

  // static String formatCurrency(double amount) {
  //   final formatter = NumberFormat.currency(symbol: AppConstants.currencySymbol);
  //   return formatter.format(amount);
  // }

  // static String formatDate(DateTime date) {
  //   return DateFormat('dd MMM yyyy').format(date);
  // }

  // static String getInitials(String name) {
  //   List<String> nameParts = name.split(' ');
  //   String initials = '';
  //   if (nameParts.length > 1) {
  //     initials = nameParts[0][0] + nameParts[1][0];
  //   } else if (nameParts.length == 1) {
  //     initials = nameParts[0][0];
  //   }
  //   return initials.toUpperCase();
  // }

  // static bool isNullOrEmpty(String? str) {
  //   return str == null || str.isEmpty;
  // }

  // static String truncateString(String text, int maxLength) {
  //   if (text.length <= maxLength) {
  //     return text;
  //   }
  //   return '${text.substring(0, maxLength)}...';
  // }

  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(20),
              child: const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context,
      String title,
      String content
      ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
  }
}