import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';

import 'text_styles.dart';

class LoadingUtil {
  static CustomProgressDialog build(
    context, {
    bool withImage = false,
    String text = "",
    bool dismissable = false,
  }) {
    CustomProgressDialog progressDialog;
    if (withImage) {
      progressDialog = CustomProgressDialog(
        context,
        backgroundColor: Colors.black.withOpacity(.5),
        dismissable: dismissable,
        dialogTransitionType: DialogTransitionType.Bubble,
        onDismiss: () {},
        loadingWidget: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Expanded(
              //   child: Lottie.asset(
              //     'assets/lottie/loading.json',
              //     fit: BoxFit.fitWidth,
              //     repeat: true,
              //   ),
              //   // Image.asset("assets/loading.jpg"),
              // ),
              SizedBox(height: 10),
              Text(
                "Tunggu sebentar, $text sedang diproses...",
                style: Styles.commonTextStyle(
                  size: 20,
                ),
              ),
              if (dismissable) ...[
                SizedBox(height: 10),
                Text(
                  "Kamu bisa meninggalkan halaman ini",
                  style: Styles.commonTextStyle(
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
              SizedBox(height: 20),
              const CircularProgressIndicator(),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      progressDialog = CustomProgressDialog(
        context,
        backgroundColor: Colors.black.withOpacity(.5),
        dismissable: dismissable,
        dialogTransitionType: DialogTransitionType.Bubble,
        onDismiss: () {},
      );
    }

    return progressDialog;
  }
}
