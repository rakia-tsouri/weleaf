import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:optorg_mobile/constants/constants.dart';
import 'dart:math';
import 'package:sprintf/sprintf.dart';

extension StringExtension on String? {
  String capitalize() {
    String? value = this;
    if (value == null || value.isEmpty) {
      return "";
    }
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  // remove part of string and return new value
  String? removeString({required String stringToBeRemoved}) {
    if (this == null) {
      return null;
    }

    // original string doesnt contains stringToBeRemoved
    if (!this!.contains(stringToBeRemoved)) {
      return this;
    }

    // original string and stringToBeRemoved are the same
    if (this == stringToBeRemoved) {
      return "";
    }
    if (this!.indexOf(stringToBeRemoved) == 0) {
      return this!.substring(stringToBeRemoved.length);
    } else if (this!.indexOf(stringToBeRemoved) + stringToBeRemoved.length ==
        this!.length) {
      return "${this!.substring(0, this!.indexOf(stringToBeRemoved))}";
    } else {
      String firstPart = this!.substring(0, this!.indexOf(stringToBeRemoved));
      String secondPart = this!.substring(
          this!.indexOf(stringToBeRemoved) + stringToBeRemoved.length);
      return "$firstPart$secondPart";
    }
  }

  bool isValidUserFirstLastName() {
    return this != null && this != "" && this != "anonymous";
  }

  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.tryParse(this ?? "") != null;
  }

  double? toDouble() {
    try {
      String? validDoubleNumber =
          this!.replaceAll(RegExp(r'[^0-9,.]'), '').replaceAll(',', '.');
      return double.parse(validDoubleNumber);
    } catch (exception) {
      return null;
    }
  }

  String format(var arguments) {
    return sprintf(this ?? "", arguments);
  }

  String toBearer() {
    return "Bearer $this";
  }

  bool isEmail() {
    if (this == null) {
      return false;
    } else {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(p);
      return regExp.hasMatch(this!);
    }
  }

// *************
// *************
  String formatFrenchPhoneNumber() {
    if (this != null) {
      // format Space every 2 digits
      if (this!.length > 1) {
        String firstDigit = this!.substring(0, 1);
        String remainDigit = this!
            .substring(1)
            .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)} ");
        return firstDigit + " " + remainDigit;
      } else {
        return this!;
      }
    }
    return "";
  }

// *************
// *************
  String getPurePhoneNumber() {
    if (this != null) {
      return this!
          .replaceAll(")", "")
          .replaceAll("(", "")
          .replaceAll(".", "")
          .replaceAll(" ", "");
    }
    return "";
  }

// *************
// *************
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

// *************
// *************
  DateTime? toDateTime({String pattern = DEFAULT_DATE_FORMAT_PATTERN}) {
    try {
      return DateFormat(pattern).parse(this!);
    } catch (ex) {
      return null;
    }
  }
}

// *************
// *************
extension DateTimeExtensions on DateTime? {
  // *************
// *************
  String? format({String pattern = DEFAULT_DATE_FORMAT_PATTERN}) {
    try {
      if (this == null) {
        return null;
      }
      return DateFormat(pattern).format(this!);
    } catch (ex) {
      return null;
    }
  }
}

extension DoubleExtensions on double {
  double widthResponsive() {
    if (kIsWeb) return this;
    return ScreenUtil().setWidth(this);
  }

  double heightResponsive() {
    if (kIsWeb) return this;
    return ScreenUtil().setHeight(this);
  }

  double spResponsive() {
    if (kIsWeb) return this;
    var result = ScreenUtil().setSp(this);
    return result;
  }

  double toRound({places = 3}) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

// +++++++++++++++++++
// +++++++++++++++++++
extension ListExtensions on List? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }
}

// +++++++++++++++++++
// +++++++++++++++++++
extension GlobalExtensions on Object? {
  bool isNull() {
    return this == null;
  }

  bool isNotNull() {
    return this != null;
  }
}

// +++++++++++++++++++++
// +++++++++++++++++++++ DioExtensions
// +++++++++++++++++++++
extension DioExtensions on Dio {
  // **************************
  // **************************
  void setHeaderJsonParam(String key, Map<String, dynamic> paramQuery) {
    options.headers[key] = json.encode(paramQuery);
  }

  void setHeaderKeyValueParam(String key, dynamic value) {
    options.headers[key] = value;
  }
}

// +++++++++++++++++++++
// +++++++++++++++++++++
// +++++++++++++++++++++
extension IntExtensions on int? {
  String amountFormat({
    String currency = CURRENCY_SYMBOL,
    bool withCurrency = true,
    String locale = 'fr_FR',
    int fractionDigits = 0,
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: withCurrency ? currency : '',
      decimalDigits: fractionDigits,
    );
    return format.format(this ?? 0);
  }
}


// +++++++++++++++++++++
// +++++++++++++++++++++ NullDoubleExtensions double
// +++++++++++++++++++++
extension NullDoubleExtensions on double? {
  String amountFormat({
    String currency = CURRENCY_SYMBOL,
    bool withCurrency = true,
    String locale = 'fr_FR',
    int fractionDigits = 2,
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: withCurrency ? currency : '',
      decimalDigits: fractionDigits,
    );
    return format.format(this ?? 0);
  }
}


// +++++++++++++++++++
// +++++++++++++++++++
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// +++++++++++++++++++
// +++++++++++++++++++

