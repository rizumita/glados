import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

typedef WidgetTesterCallback<T> = FutureOr<void> Function(WidgetTester widgetTester, T input);
typedef WidgetTesterCallbackWithRandom<T> = FutureOr<void> Function(WidgetTester widgetTester, T input, Random random);
typedef WidgetTester2Callback<A, B> = FutureOr<void> Function(WidgetTester widgetTester, A firstInput, B secondInput);
typedef WidgetTester2CallbackWithRandom<A, B> = FutureOr<void> Function(
    WidgetTester widgetTester, A firstInput, B secondInput, Random random);
typedef WidgetTester3Callback<A, B, C> = FutureOr<void> Function(
    WidgetTester widgetTester, A firstInput, B secondInput, C thirdInput);
typedef WidgetTester3CallbackWithRandom<A, B, C> = FutureOr<void> Function(
    WidgetTester widgetTester, A firstInput, B secondInput, C thirdInput, Random random);

Future<bool> succeeds<T>(WidgetTesterCallback<T> tester, WidgetTester widgetTester, T input) async {
  try {
    await tester(widgetTester, input);
    return true;
  } catch (e) {
    return false;
  }
}
