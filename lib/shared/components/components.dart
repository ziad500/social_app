// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/iconBroken.dart';
import 'package:social_app/styles/colors.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

PreferredSizeWidget defaultAppBar(
        {String? title,
        List<Widget>? actions,
        required BuildContext context}) =>
    AppBar(
      titleSpacing: 5.0,
      title: Text(title ?? ''),
      actions: actions,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(IconBroken.Arrow___Left_2)),
    );

Widget defaultFormField(
  context, {
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String?)? validate,
  String? label,
  String? hint,
  Color? bodercolor,
  IconData? prefix,
  IconData? suffix,
  int maxlines = 1,
  double hintsize = 14.0,
  double verticalpadding = 13.0,
  double horizontalpadding = 15.0,
  Color borderEnableColor = Colors.blue,
  Color borderColor = Colors.grey,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
      style: Theme.of(context).textTheme.bodyText1,
    );
Widget codeFormField(
  context, {
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChange,
  Function()? onTap,
  required String? Function(String?)? validate,
  int maxlines = 1,
  double verticalpadding = 13.0,
  double horizontalpadding = 0.0,
}) =>
    TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next, // Moves focus to next.
      controller: controller,
      keyboardType: type,
      maxLines: maxlines,
      maxLength: 1,
      onFieldSubmitted: onSubmit,
      onChanged: (_) => FocusScope.of(context).nextFocus(),
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.red)),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: verticalpadding, horizontal: horizontalpadding),
      ),
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );

Widget defaultButton(
        {double width = double.infinity,
        bool isUpperCase = true,
        double radius = 30.0,
        required Function()? function,
        required String text,
        double verticalpadding = 14.0,
        double textsize = 14.0}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        color: defaultColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: Colors.blue,
      ),
    );

void showToast({
  required String? text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: '$text',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
