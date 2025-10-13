import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/internal/application/TextType.dart';
import '../utils/Colors.dart';
import '../utils/Images.dart';
import '../utils/ScreenUtils.dart' as Responsive;

text(String text, double textSize, TextType type) {
  String textType = getTextType(type);

  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      decoration: TextDecoration.none,
      color: colorPrimaryDark,
      fontSize: textSize,
      fontFamily: textType,
    ),
  );
}

expansionListTitle(Widget? icon, String title, String description, bool flip) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        enableFeedback: true,
        minLeadingWidth: 2,
        leading: icon,
        title: navigatorTitles(title, description),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: flip ? 14 : 0,
          right: !flip ? 24 : 0,
        ),
        child: Divider(color: colorPrimary),
      ),
    ],
  );
}

navigatorHeader(bool state, Widget image, String title) {
  if (state) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorPrimaryDark2,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(8),
          width: 40,
          height: 40,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: image,
            ),
          ),
        ),

        textWithColorAndLimit(
          title,
          14,
          TextType.Bold,
          1,
          colorMilkWhite,
          TextAlign.center,
        ),
      ],
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        color: colorPrimaryDark2,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(8),
      width: 30,
      height: 30,
      child: Center(
        child: ClipRRect(borderRadius: BorderRadius.circular(5), child: image),
      ),
    );
  }
}

navigatorFooter(
  String title,
  String subtitle,
  Color color,
  Widget leadingWidget,
  bool state,
) {
  if (state) {
    return Container(
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorPrimaryDark2,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(8),
            width: 40,
            height: 40,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: leadingWidget,
              ),
            ),
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWithColor(title, 14, TextType.Bold, colorMilkWhite),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: textWithColor(
                    subtitle,
                    8,
                    TextType.Regular,
                    colorMilkWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        color: colorPrimaryDark2,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(8),
      width: 30,
      height: 30,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: leadingWidget,
        ),
      ),
    );
  }
}

navigatorListHeader(
  String title,
  String subtitle,
  Color color,
  Widget leadingWidget,
  Widget trailingWidget,
) {
  return Container(
    decoration: BoxDecoration(
      color: colorPrimaryDark,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorPrimaryDark2,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(4),
                width: 40,
                height: 40,
                child: Center(child: leadingWidget),
              ),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithColor(title, 14, TextType.Bold, colorMilkWhite),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: textWithColor(
                        subtitle,
                        8,
                        TextType.Regular,
                        colorMilkWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: colorPrimaryDark,
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(4),
          width: 40,
          height: 40,
          child: Center(child: trailingWidget),
        ),
      ],
    ),
  );
}

navigatorListTile(
  String title,
  String description,
  IconData? leadingIcon,
  IconData? trailingIcon,
  GestureTapCallback? clickAction,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        onTap: clickAction,
        enableFeedback: true,
        hoverColor: colorPrimary,
        splashColor: colorPrimary,
        leading: leadingIcon != null
            ? Icon(leadingIcon, size: 22, color: colorPrimary)
            : null,
        trailing: trailingIcon != null
            ? Icon(trailingIcon, size: 22, color: colorPrimary)
            : null,
        subtitle: Text(
          description,
          style: TextStyle(
            color: colorPrimaryDark,
            fontFamily: getTextType(TextType.Regular),
            fontSize: 8,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colorPrimaryDark,
            fontFamily: getTextType(TextType.Bold),
            fontSize: 14,
          ),
        ),
      ),

      Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        color: colorPrimaryDark2,
        height: 4,
      ),
    ],
  );
}

navigatorExpansionListTile(
  BuildContext context,
  IconData? leadingIcon,
  IconData? trailingIcon,
  String title,
  String description,
  List<Widget> children,
) {
  return ListTileTheme(
    contentPadding: const EdgeInsets.all(0),
    dense: true,
    child: Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: colorMilkWhite,
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        showTrailingIcon: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListTile(
                enableFeedback: true,
                hoverColor: colorPrimary,
                splashColor: colorPrimary,
                leading: leadingIcon != null
                    ? Icon(leadingIcon, size: 22, color: colorPrimary)
                    : null,
                trailing: trailingIcon != null
                    ? Icon(trailingIcon, size: 22, color: colorPrimary)
                    : null,
                subtitle: Text(
                  description,
                  style: TextStyle(
                    color: colorGrey,
                    fontFamily: getTextType(TextType.Regular),
                    fontSize: 8,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: colorMilkWhite,
                    fontFamily: getTextType(TextType.Bold),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              color: colorPrimaryDark2,
              height: 4,
            ),
          ],
        ),
        children: children,
      ),
    ),
  );
}

expansionPanelButton(
  String label,
  String details,
  Color color,
  VoidCallback? onPressed,
) {
  return InkWell(
    onTap: onPressed,
    child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textWithColor(label, 14, TextType.Bold, colorMilkWhite),

            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: textWithColor(
                details,
                10,
                TextType.SemiBold,
                colorMilkWhite,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              color: colorPrimaryDark2,
              height: 4,
            ),
          ],
        ),
      ),
    ),
  );
}

navigatorTitles(String title, String description) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: colorMilkWhite,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: getTextType(TextType.Regular),
        ),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
      Text(
        description,
        textAlign: TextAlign.left,
        maxLines: 2,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: colorGrey,
          fontWeight: FontWeight.w200,
          fontFamily: getTextType(TextType.Regular),
          fontSize: 7,
        ),
      ),
    ],
  );
}

raisedButton(String label, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.only(left: 16, top: 18, bottom: 18, right: 16),
    ),

    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        decoration: TextDecoration.none,
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Bold),
      ),
    ),
  );
}

roundedCornerButton(String label, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 24, right: 16),
    ),

    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        decoration: TextDecoration.none,
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Bold),
      ),
    ),
  );
}

buttonWithWidget(Widget widget, Color? color, VoidCallback? clickAction) {
  return ElevatedButton(
    onPressed: clickAction,
    style: ElevatedButton.styleFrom(
      minimumSize: Size.zero,
      backgroundColor: color ?? colorPrimary,
      padding: EdgeInsets.zero,
    ),

    child: widget,
  );
}

iconButton(Widget icon, Color color, VoidCallback? onPressed) {
  return IconButton(onPressed: onPressed, icon: icon);
}

textButton(String label, VoidCallback? onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      textAlign: TextAlign.left,

      style: TextStyle(
        decoration: TextDecoration.none,
        color: colorPrimary,
        fontSize: 14,
        fontFamily: getTextType(TextType.Regular),
      ),
    ),
  );
}

textButtonWithOption(
  String label,
  double textSize,
  TextType type,
  Color color,
  VoidCallback? onPressed,
) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      textAlign: TextAlign.center,

      style: TextStyle(
        decoration: TextDecoration.none,
        color: color,
        fontSize: textSize,
        fontFamily: getTextType(type),
      ),
    ),
  );
}

switchComponent(bool value, ValueChanged<bool> onChanged) {
  return Switch(
    value: value,
    onChanged: onChanged,
    activeTrackColor: colorPrimary,
    activeColor: colorReddish,
    inactiveThumbColor: colorMilkWhite,
    inactiveTrackColor: colorGrey2,
  );
}

inputFieldPassword(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  TextInputType textInputType,
  String helpers,
  bool obscured,
  GestureTapCallback? tapAction,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
  FocusNode textFieldFocusNode,
) {
  return TextFormField(
    enabled: enabled,
    obscureText: obscured,
    focusNode: textFieldFocusNode,
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: textInputType,
    controller: controller,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Icon(CupertinoIcons.lock_fill, size: 20, color: colorPrimary),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      suffixIcon: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: GestureDetector(
          onTap: tapAction,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 16),
            child: obscured
                ? Icon(
                    CupertinoIcons.eye_slash_fill,
                    size: 20,
                    color: colorPrimary,
                  )
                : Icon(
                    CupertinoIcons.eye_solid,
                    size: 20,
                    color: colorPrimaryDark,
                  ),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),

    validator: validator,
  );
}

textWithAlignAndColor(
  String text,
  double textSize,
  TextType type,
  TextAlign align,
  Color color,
) {
  String textType = getTextType(type);

  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      decoration: TextDecoration.none,
      color: color,
      fontSize: textSize,
      fontFamily: textType,
    ),
  );
}

textWithColor(String text, double textSize, TextType type, Color color) {
  String textType = getTextType(type);

  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      decoration: TextDecoration.none,
      color: color,
      fontSize: textSize,
      fontFamily: textType,
    ),
  );
}

inputFieldUserCode(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  TextInputType textInputType,
  String helpers,
  IconData prefixIcon,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.center,
    textInputAction: TextInputAction.done,
    keyboardType: textInputType,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    textCapitalization: TextCapitalization.characters,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(prefixIcon, size: 20, color: colorPrimary),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

inputPhoneNumber(
  String label,
  String helpers,
  bool enabled,
  PhoneController controller,
  FormFieldValidator<PhoneNumber> validator,
  ValueChanged<PhoneNumber>? onChange,
) {
  return PhoneInput(
    enabled: enabled,
    validator: validator,
    controller: controller,
    countrySelectorNavigator: CountrySelectorNavigator.dialog(
      countryCodeStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 12.0,
        fontFamily: getTextType(TextType.Regular),
      ),
      countryNameStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16.0,
        fontFamily: getTextType(TextType.Bold),
      ),
      searchInputDecoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Icon(CupertinoIcons.search, size: 20, color: colorPrimary),
        ),
        prefixIconColor: colorPrimaryDark,
        errorMaxLines: 5,
        helperMaxLines: 5,
        isDense: true,
        contentPadding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 35,
          minHeight: 35,
        ),
        fillColor: colorGrey.withOpacity(0.2),
        filled: true,
        labelText: "SEARCH",
        helperText: "Search for a phone number country code above.",
        helperStyle: TextStyle(
          color: colorGrey2,
          fontSize: 12,
          fontFamily: getTextType(TextType.Regular),
        ),
        hintStyle: TextStyle(
          color: colorGrey2,
          fontSize: 10,
          fontFamily: getTextType(TextType.Regular),
        ),
        errorStyle: TextStyle(
          color: colorNegative,
          fontSize: 12,
          fontFamily: getTextType(TextType.Regular),
        ),
        labelStyle: TextStyle(
          color: colorPrimaryDark,
          fontSize: 16,
          fontFamily: getTextType(TextType.Regular),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: colorNegative, width: 8.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: colorPrimary, width: 2.0),
        ),
        border: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: colorPrimary, width: 6.0),
        ),
      ),
      searchInputTextStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16.0,
        fontFamily: getTextType(TextType.Bold),
      ),
      defaultSearchInputIconColor: colorPrimary,
      flagSize: 22,
      flagShape: BoxShape.circle,
      showCountryName: true,
      showCountryFlag: true,
    ),
    showFlagInInput: true,
    flagShape: BoxShape.circle,
    enableSuggestions: false,
    flagSize: 24,
    defaultCountry: IsoCode.KE,
    countryCodeStyle: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.phone,
    autovalidateMode: AutovalidateMode.disabled,
    decoration: InputDecoration(
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

inputField(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  TextInputType textInputType,
  String helpers,
  IconData prefixIcon,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: textInputType,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(prefixIcon, size: 20, color: colorPrimary),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

inputFieldOnKeyPress(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  TextInputType textInputType,
  String helpers,
  Widget prefixIcon,
  ValueChanged<String>? onChange,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    onChanged: onChange,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Bold),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: textInputType,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: prefixIcon,
      ),
      prefixIconColor: Colors.grey,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

selectFieldCustom(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  TextInputType textInputType,
  String helpers,
  GestureTapCallback? onTap,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    onTap: onTap,
    autofocus: false,
    showCursor: false,
    readOnly: true,
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: textInputType,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      suffixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          Icons.arrow_drop_down_rounded,
          color: colorPrimary,
          size: 25,
        ),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(CupertinoIcons.option, size: 20, color: colorPrimary),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

windowOperations() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(child: MoveWindow()),
      MinimizeWindowButton(colors: buttonColors),
      MaximizeWindowButton(colors: buttonColors),
      CloseWindowButton(colors: closeButtonColors),
    ],
  );
}

final buttonColors = WindowButtonColors(
  iconNormal: colorAccent,
  mouseOver: colorPrimary,
  mouseDown: colorPrimary,
  iconMouseOver: colorMilkWhite,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFF960000),
  mouseDown: colorPrimary,
  iconNormal: colorPrimary,
  iconMouseOver: colorPrimary,
);

String getTextType(TextType type) {
  switch (type) {
    case TextType.Bold:
      return "spiroBold";
    case TextType.Light:
      return "spiroLight";
    case TextType.Regular:
      return "spiroRegular";
    case TextType.SemiBold:
      return "spiroSemiBold";
    case TextType.Medium:
      return "spiroMedium";
    default:
      return "spiroRegular";
  }
}

textWithLimit(String text, double textSize, int limit, TextType type) {
  String textType = getTextType(type);

  return Text(
    text,
    textAlign: TextAlign.left,
    maxLines: limit,
    style: TextStyle(
      decoration: TextDecoration.none,
      color: Colors.white,
      fontSize: textSize,
      fontFamily: textType,
    ),
  );
}

textWithColorAndLimit(
  String text,
  double textSize,
  TextType type,
  int limit,
  Color color,
  TextAlign align,
) {
  String textType = getTextType(type);

  return Text(
    text,
    textAlign: align,
    maxLines: limit,
    style: TextStyle(
      decoration: TextDecoration.none,
      color: color,
      fontSize: textSize,
      fontFamily: textType,
    ),
  );
}

roundedspiroButton(String label, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorPrimaryDark,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 3, color: colorPrimary),
        borderRadius: BorderRadius.circular(35),
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 50, right: 50),
    ),

    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        decoration: TextDecoration.none,
        color: colorPrimary,
        fontSize: 16,
        fontFamily: getTextType(TextType.Bold),
      ),
    ),
  );
}

buttonRounded(Icon icon, Color background, VoidCallback? callback) {
  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(9),
    ),
    child: icon,
  );
}

userImageRounded(Widget widget, Color background, VoidCallback? callback) {
  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(9),
    ),
    child: widget,
  );
}

inputTextArea(
  String label,
  FormFieldValidator<String> validator,
  bool enabled,
  String helpers,
  TextEditingController controller,
  int minLines,
  int maxLines,
  List<TextInputFormatter> inputFormatters,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    minLines: minLines,
    maxLines: maxLines,
    textCapitalization: TextCapitalization.sentences,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.start,
    textInputAction: TextInputAction.newline,
    keyboardType: TextInputType.multiline,
    autovalidateMode: AutovalidateMode.disabled,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      prefixIconColor: Colors.grey,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
  );
}

datePicker(
  String label,
  String helpers,
  FormFieldValidator<DateTime> validator,
  TextEditingController controller,
  DateTime firstDate,
  DateTime lastDate,
  DateTime? initialDate,
) {
  return DateTimeField(
    format: DateFormat('EEE, d MMM yyyy'),
    validator: validator,
    controller: controller,
    resetIcon: Icon(CupertinoIcons.clear_thick, size: 20, color: colorReddish),
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    autovalidateMode: AutovalidateMode.disabled,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          CupertinoIcons.calendar_badge_plus,
          size: 20,
          color: colorPrimary,
        ),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),
    onShowPicker: (context, currentValue) {
      return showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: initialDate ?? currentValue ?? DateTime.now(),
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: colorPrimary, // header background color
                onPrimary: colorMilkWhite, // header text color
                surface: colorPrimaryDark, // background color
                onSurface: colorPrimaryDark, // text color
              ),

              datePickerTheme: DatePickerThemeData(
                backgroundColor: colorMilkWhite,
                elevation: 2,
                headerHeadlineStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),
                headerHelpStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Regular),
                  fontSize: 12,
                ),
                weekdayStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),
                dayStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 14,
                ),

                headerBackgroundColor: colorPrimary,
                headerForegroundColor: colorPrimaryDark,
                rangePickerHeaderBackgroundColor: colorPrimary,
                rangePickerHeaderForegroundColor: colorPrimaryDark,

                todayBorder: BorderSide(color: colorPrimaryDark, width: 3.0),
                yearStyle: TextStyle(
                  color: colorGrey,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),

                rangePickerBackgroundColor: colorPrimaryDark,
                rangePickerElevation: 2,
                dividerColor: colorPrimaryDark2,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  prefixIconColor: colorPrimary,
                  suffixIconColor: colorPrimaryDark,
                  errorMaxLines: 5,
                  helperMaxLines: 5,
                  isDense: true,
                  fillColor: Colors.transparent,
                  filled: true,
                  helperStyle: TextStyle(
                    color: colorGrey2,
                    fontSize: 12,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  hintStyle: TextStyle(
                    color: colorGrey2,
                    fontSize: 10,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  errorStyle: TextStyle(
                    color: colorNegative,
                    fontSize: 12,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  labelStyle: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 16,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: colorNegative, width: 8.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorPrimary, width: 2.0),
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: colorPrimary, width: 6.0),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
    },
  );
}

dateTimePicker(
  String label,
  String helpers,
  FormFieldValidator<DateTime> validator,
  TextEditingController controller,
  DateTime firstDate,
  DateTime lastDate,
) {
  return DateTimeField(
    format: DateFormat('EEEE, d MMMM yyyy HH:mm:ss'),
    validator: validator,
    controller: controller,
    resetIcon: Icon(CupertinoIcons.clear_thick, size: 20, color: colorReddish),
    style: TextStyle(
      color: colorPrimaryDark,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Regular),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    autovalidateMode: AutovalidateMode.disabled,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          CupertinoIcons.calendar_badge_plus,
          size: 20,
          color: colorPrimary,
        ),
      ),
      prefixIconColor: colorPrimaryDark,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: colorGrey.withOpacity(0.2),
      filled: true,
      labelText: label,
      helperText: helpers,
      helperStyle: TextStyle(
        color: colorGrey2,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: TextStyle(
        color: colorGrey2,
        fontSize: 10,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorStyle: TextStyle(
        color: colorNegative,
        fontSize: 12,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: colorPrimaryDark,
        fontSize: 16,
        fontFamily: getTextType(TextType.Regular),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: colorNegative, width: 8.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      border: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorPrimary, width: 6.0),
      ),
    ),

    onShowPicker: (context, currentValue) {
      return showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: currentValue ?? DateTime.now(),
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: colorPrimary, // <-- SEE HERE
                onPrimary: colorPrimaryDark, // <-- SEE HERE
                onSurface: colorPrimaryDark, // <-- SEE HERE
              ),

              datePickerTheme: DatePickerThemeData(
                backgroundColor: colorMilkWhite,
                elevation: 2,
                headerHeadlineStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),
                headerHelpStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Regular),
                  fontSize: 12,
                ),
                weekdayStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),
                dayStyle: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 14,
                ),

                headerBackgroundColor: colorPrimary,
                headerForegroundColor: colorPrimaryDark,
                rangePickerHeaderBackgroundColor: colorPrimary,
                rangePickerHeaderForegroundColor: colorPrimaryDark,

                todayBorder: BorderSide(color: colorPrimaryDark, width: 3.0),
                yearStyle: TextStyle(
                  color: colorGrey,
                  fontFamily: getTextType(TextType.Bold),
                  fontSize: 16,
                ),

                rangePickerBackgroundColor: colorPrimaryDark,
                rangePickerElevation: 2,
                dividerColor: colorPrimaryDark2,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  prefixIconColor: colorPrimary,
                  suffixIconColor: colorPrimaryDark,
                  errorMaxLines: 5,
                  helperMaxLines: 5,
                  isDense: true,
                  fillColor: Colors.transparent,
                  filled: true,
                  helperStyle: TextStyle(
                    color: colorGrey2,
                    fontSize: 12,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  hintStyle: TextStyle(
                    color: colorGrey2,
                    fontSize: 10,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  errorStyle: TextStyle(
                    color: colorNegative,
                    fontSize: 12,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  labelStyle: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 16,
                    fontFamily: getTextType(TextType.Regular),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: colorNegative, width: 8.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorPrimary, width: 2.0),
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorPrimaryDark, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: colorPrimary, width: 6.0),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
      ).then((DateTime? date) async {
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: colorPrimary, // <-- SEE HERE
                    onPrimary: colorPrimaryDark, // <-- SEE HERE
                    onSurface: colorPrimaryDark, // <-- SEE HERE
                  ),
                  timePickerTheme: TimePickerThemeData(
                    backgroundColor: colorMilkWhite,
                    /*  hourMinuteShape: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      borderSide: BorderSide(color: colorGrey, width: 3.0),
                    ),*/
                    dayPeriodBorderSide: const BorderSide(
                      color: Colors.orange,
                      width: 4,
                    ),
                    dayPeriodColor: colorWhite,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    dayPeriodTextColor: colorPrimaryDark,

                    hourMinuteColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? colorMilkWhite
                          : colorPrimaryAccent,
                    ),
                    hourMinuteTextColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? colorPrimaryDark
                          : colorPrimary,
                    ),
                    dialHandColor: colorPrimary,
                    dialBackgroundColor: colorMilkWhite,

                    hourMinuteTextStyle: TextStyle(
                      fontSize: 34,
                      fontFamily: getTextType(TextType.Bold),
                      color: colorPrimaryDark,
                    ),

                    dayPeriodTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: getTextType(TextType.Bold),
                      color: colorPrimaryDark,
                    ),

                    helpTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: getTextType(TextType.Bold),
                      color: colorPrimaryDark,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding: const EdgeInsets.all(10),
                      prefixIconColor: colorPrimary,
                      suffixIconColor: colorPrimaryDark,
                      errorMaxLines: 5,
                      helperMaxLines: 5,
                      isDense: true,
                      fillColor: Colors.transparent,
                      filled: true,
                      helperStyle: TextStyle(
                        color: colorGrey2,
                        fontSize: 12,
                        fontFamily: getTextType(TextType.Regular),
                      ),
                      hintStyle: TextStyle(
                        color: colorGrey2,
                        fontSize: 10,
                        fontFamily: getTextType(TextType.Regular),
                      ),
                      errorStyle: TextStyle(
                        color: colorNegative,
                        fontSize: 12,
                        fontFamily: getTextType(TextType.Regular),
                      ),
                      labelStyle: TextStyle(
                        color: colorPrimaryDark,
                        fontSize: 16,
                        fontFamily: getTextType(TextType.Regular),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: colorNegative,
                          width: 8.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(0),
                        ),
                        borderSide: BorderSide(color: colorPrimary, width: 2.0),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(0),
                        ),
                        borderSide: BorderSide(
                          color: colorPrimaryDark,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: colorPrimary, width: 6.0),
                      ),
                    ),

                    dialTextColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? colorPrimaryDark
                          : colorPrimaryDark,
                    ),
                    entryModeIconColor: colorTinted,
                  ),
                  dialogTheme: DialogThemeData(
                    backgroundColor: colorPrimaryDark,
                    elevation: 5,
                    contentTextStyle: TextStyle(
                      color: colorPrimaryDark,
                      fontFamily: getTextType(TextType.Regular),
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: colorMilkWhite),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    titleTextStyle: TextStyle(
                      color: colorPrimaryDark,
                      fontFamily: getTextType(TextType.Bold),
                      fontSize: 16,
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: colorPrimary,
                      backgroundColor: colorPrimaryDark2,
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: getTextType(TextType.Bold),
                      ), // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      });
    },
  );
}

outlinedButton(VoidCallback? onPressed, String label) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: colorPrimary,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      side: BorderSide(width: 2, color: colorPrimary, style: BorderStyle.solid),
    ),

    child: Text(
      label,
      textAlign: TextAlign.left,
      style: TextStyle(
        decoration: TextDecoration.none,
        color: colorPrimary,
        fontSize: 14,
        fontFamily: getTextType(TextType.Bold),
      ),
    ),
  );
}

buttonWithIconAndLabelVertical(
  String icon,
  String label,
  Color primary,
  Color background,
  double radius,
  double textSize,
  double iconSize,
  VoidCallback? onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
    ),

    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: iconSize, height: iconSize),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: primary,
              fontSize: textSize,
              fontFamily: getTextType(TextType.Regular),
            ),
          ),
        ),
      ],
    ),
  );
}

buttonWithIconAndLabel(
  IconData icon,
  String label,
  Color primary,
  Color background,
  double radius,
  VoidCallback? onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: primary),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: primary,
              fontSize: 14,
              fontFamily: getTextType(TextType.Regular),
            ),
          ),
        ),
      ],
    ),
  );
}

roundedIconButton(Widget icon, Color color, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: color,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(12),
    ),

    child: icon,
  );
}

rectangularCurvedButton(
  IconData icon,
  Color background,
  Color iconColor,
  double size,
  VoidCallback? onPressed,
) {
  return SizedBox(
    width: size,
    height: size,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.only(left: 0),
      ),

      child: Icon(icon, color: iconColor),
    ),
  );
}

squareButton(
  String icon,
  Color backGround,
  Color iconColor,
  VoidCallback? onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: backGround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      padding: const EdgeInsets.all(15),
    ),

    child: SvgPicture.asset(
      icon,
      width: double.infinity,
      height: double.infinity,
      color: iconColor,
    ),
  );
}

Color getCheckBoxColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return colorPrimary;
  }
  return colorPrimary;
}

roundedStyleIconButton(IconData icon, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorPrimary.withOpacity(0.0),
      padding: const EdgeInsets.all(24),
      shape: CircleBorder(side: BorderSide(color: colorPrimary, width: 1)),
    ),
    child: Icon(icon, size: 20, color: colorPrimary),
  );
}

backButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => {Navigator.pop(context)},
    style: ElevatedButton.styleFrom(
      elevation: 3,
      shape: CircleBorder(side: BorderSide(color: colorPrimary, width: 1)),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 24),
    ),

    child: Icon(CupertinoIcons.left_chevron, color: colorPrimary, size: 18),
  );
}

backButtonWithAction(BuildContext context, VoidCallback? action) {
  return ElevatedButton(
    onPressed: action,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: Colors.transparent,
      shape: CircleBorder(side: BorderSide(color: colorPrimary, width: 1)),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 24),
    ),

    child: Icon(Icons.arrow_back, color: colorPrimary, size: 18),
  );
}

backButtonWithActionAndIcon(
  IconData icon,
  BuildContext context,
  VoidCallback? action,
) {
  return ElevatedButton(
    onPressed: action,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorWhite,
      shape: CircleBorder(side: BorderSide(color: colorPrimary, width: 1)),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 24),
    ),

    child: Icon(icon, color: colorPrimary, size: 18),
  );
}

titleAndDescription(String title, String description) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      /*  textWithColor(title, 18, TextType.Bold, colorMilkWhite),
    Padding(padding: const EdgeInsets.only(top: 8),
    child: textWithColor(description, 10, TextType.Regular, colorGrey),)*/
      textWithColor(title, 20, TextType.SemiBold, colorPrimaryDark),

      textWithColor(description, 14, TextType.SemiBold, colorPrimaryDark),
    ],
  );
}

animatedPageIndicator(int index, int count, IndicatorEffect effect) {
  return AnimatedSmoothIndicator(
    activeIndex: index % 10,
    count: count < 10 ? count : 10,
    effect: effect,
  );
}

registrationButtonWithIcon(image, VoidCallback? callback, int type) {
  Widget widget;

  EdgeInsets padding;
  if (type == 4) {
    padding = const EdgeInsets.all(40);
    widget = ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        image,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  } else if (type == 2) {
    padding = const EdgeInsets.all(40);
    widget = Icon(CupertinoIcons.camera_circle, size: 180);
  } else {
    padding = const EdgeInsets.all(0);
    widget = ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.file(
        File(image),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  return ElevatedButton(
    onPressed: callback,
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: colorMilkWhite,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    child: widget,
  );
}

inputCodeVerifier(
  TextEditingController controller,
  int pinLength,
  bool showInput,
  ValueChanged<String> onChange,
  Function(String)? onComplete,
  StreamController<ErrorAnimationType>? errorController,
  BuildContext context,
) {
  return PinCodeTextField(
    appContext: context,
    length: pinLength,
    obscureText: showInput,
    useHapticFeedback: true,
    hapticFeedbackTypes: HapticFeedbackTypes.selection,
    blinkWhenObscuring: true,
    autoDismissKeyboard: true,
    obscuringCharacter: '*',
    animationType: AnimationType.scale,
    cursorColor: colorPrimary,
    animationDuration: const Duration(milliseconds: 300),
    textStyle: TextStyle(
      decoration: TextDecoration.none,
      color: colorPrimaryDark,
      fontSize: 16,
      fontFamily: getTextType(TextType.Bold),
    ),
    enableActiveFill: true,
    errorAnimationController: errorController,
    controller: controller,
    keyboardType: TextInputType.number,
    autoDisposeControllers: true,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.underline,
      activeColor: colorPrimary,
      selectedColor: colorPrimary,
      inactiveColor: colorGrey.withOpacity(0.2),
      fieldWidth: 50,
      selectedFillColor: colorMilkWhite,
      inactiveFillColor: colorWhite,
      borderWidth: 2,
      errorBorderColor: colorReddish,
      activeFillColor: colorPrimary,
    ),
    validator: (v) {
      if (v != null) {
        if (v.length <= 4) {
          return "Required";
        } else {
          return null;
        }
      }
      return "Required";
    },
    onChanged: (value) {
      //No-op
    },
    beforeTextPaste: (text) {
      return false;
    },
    errorAnimationDuration: 2,
    hintStyle: TextStyle(
      color: colorPrimaryDark,
      fontSize: 8,
      fontFamily: getTextType(TextType.Regular),
    ),
    pastedTextStyle: const TextStyle(
      color: colorPrimaryDark,
      fontWeight: FontWeight.bold,
    ),
  );
}

splitView(Widget view1, Widget view2, bool option) {
  if (option) {
    return view1;
  } else {
    return view2;
  }
}

setDrawerCompanyLogo(String logo, double dimensions) {
  if (logo.isNotEmpty) {
    return Image.memory(
      base64Decode(logo),
      fit: BoxFit.fill,
      width: dimensions,
      height: dimensions,
    );
  }

  return Image.asset(
    logoPng,
    fit: BoxFit.fill,
    width: dimensions,
    height: dimensions,
  );
}

searchField(bool enabled, ValueChanged<String>? change) {
  return TextFormField(
    enabled: enabled,
    onChanged: change,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Bold),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.disabled,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(CupertinoIcons.search, size: 20, color: colorMilkWhite),
      ),
      prefixIconColor: colorMilkWhite,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: Colors.transparent,
      filled: true,
      labelText: "Search",
      helperText: "Enter your search criteria.",
      helperStyle: TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: TextStyle(
        color: colorPrimary,
        fontSize: 11,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontFamily: getTextType(TextType.Bold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorPrimary, width: 4.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorGrey, width: 3.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorGrey, width: 3.0),
      ),
    ),
  );
}

searchFieldMain(
  FormFieldValidator<String> validator,
  bool enabled,
  TextEditingController controller,
  VoidCallback? onClear,
) {
  return TextFormField(
    enabled: enabled,
    validator: validator,
    controller: controller,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: getTextType(TextType.Bold),
    ),
    maxLines: 1,
    cursorColor: colorPrimary,
    autofocus: false,
    textAlign: TextAlign.left,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.disabled,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Icon(CupertinoIcons.search, size: 20, color: colorMilkWhite),
      ),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(left: 0, right: 8),
        child: IconButton(
          onPressed: onClear,
          icon: Icon(
            CupertinoIcons.clear_circled,
            size: 24,
            color: colorNegative,
          ),
        ),
      ),
      prefixIconColor: colorMilkWhite,
      errorMaxLines: 5,
      helperMaxLines: 5,
      isDense: true,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      fillColor: Colors.transparent,
      filled: true,
      labelText: 'Search',
      helperText: 'Enter your search criteria above.',
      helperStyle: TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontFamily: getTextType(TextType.Regular),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: TextStyle(
        color: colorPrimary,
        fontSize: 11,
        fontFamily: getTextType(TextType.Regular),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontFamily: getTextType(TextType.Bold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorPrimary, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorPrimary, width: 4.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorGrey, width: 3.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        borderSide: BorderSide(color: colorGrey, width: 3.0),
      ),
    ),
  );
}

showTerminateAction() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    return SizedBox(height: 30, child: windowOperations());
  } else {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(logoPng, width: 20, height: 20, fit: BoxFit.fitHeight),

            Padding(
              padding: const EdgeInsets.only(left: 6, right: 16),
              child: text("spiro", 18, TextType.SemiBold),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curveHeight = 20.0; // Increase the curve height to widen the curves
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2 - curveHeight, 0);
    path.quadraticBezierTo(
      size.width / 2,
      curveHeight,
      size.width / 2 + curveHeight,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + curveHeight, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - curveHeight,
      size.width / 2 - curveHeight,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget pieChartIndicator({
  required Color color,
  required String text,
  required bool isSquare,
  required double size,
  required Color textColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),
      ),
      const SizedBox(width: 4),
      textWithColor(text, 10, TextType.Bold, textColor),
    ],
  );
}
