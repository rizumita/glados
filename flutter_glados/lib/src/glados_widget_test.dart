// ignore_for_file: avoid_print
import 'package:flutter_glados/src/utils.dart';
import 'package:flutter_test/flutter_test.dart' as test_package;
import 'package:glados/glados.dart';
import 'package:meta/meta.dart';

extension GladosWidgetTest<T> on Glados<T> {
  @isTest
  void testWidgets(
    String description,
    WidgetTesterCallback body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    final stats = Statistics();

    test_package.testWidgets(
      '$description (testing ${explore.numRuns} '
      '${explore.numRuns == 1 ? 'input' : 'inputs'})',
      (tester) async {
        /// Explores the input space for inputs that break the property. This works
        /// by gradually increasing the size. Returns the first value where the
        /// property is broken or null if no value was found.
        Future<Shrinkable<T>?> explorePhase() async {
          var count = 0;
          var size = explore.initialSize;

          while (count < explore.numRuns) {
            stats.exploreCounter++;
            final input = generator(explore.random, size.ceil());
            if (!await succeeds(body, tester, input.value)) {
              return input;
            }

            count++;
            size += explore.speed;
          }
          return null;
        }

        /// Shrinks the given value repeatedly. Returns the shrunk input.
        Future<T> shrinkPhase(Shrinkable<T> initialErrorInducingInput) async {
          var input = initialErrorInducingInput;

          outer:
          while (true) {
            for (final shrunkInput in input.shrink()) {
              stats.shrinkCounter++;
              if (!await succeeds(body, tester, shrunkInput.value)) {
                input = shrunkInput;
                continue outer;
              }
            }
            break;
          }
          return input.value;
        }

        final errorInducingInput = await explorePhase();
        if (errorInducingInput == null) return;

        final shrunkInput = await shrinkPhase(errorInducingInput);
        print('Tested ${stats.exploreCounter} '
            '${stats.exploreCounter == 1 ? 'input' : 'inputs'}, shrunk '
            '${stats.shrinkCounter} ${stats.shrinkCounter == 1 ? 'time' : 'times'}.'
            '\nFailing for input: $shrunkInput');
        final output = body(tester, shrunkInput); // This should fail the test again.

        throw PropertyTestNotDeterministic(shrunkInput, output);
      },
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }

  @isTest
  void testWidgetsWithRandom(
    String description,
    WidgetTesterCallbackWithRandom body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    final random = explore.random.nextRandom();
    testWidgets(
      description,
      (tester, a) => body(tester, a, random.nextRandom()),
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }
}

extension Glados2WidgetTest<First, Second> on Glados2<First, Second> {
  @isTest
  void testWidgets(
    String description,
    WidgetTester2Callback body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    Glados(
      any.combine2(
        firstGenerator,
        secondGenerator,
        (First a, Second b) => [a, b],
      ),
    ).testWidgets(
      description,
      (tester, input) => body(tester, input[0] as First, input[1] as Second),
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }

  @isTest
  void testWidgetsWithRandom(
    String description,
    WidgetTester2CallbackWithRandom body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    final random = explore.random.nextRandom();
    testWidgets(
      description,
      (tester, a, b) => body(tester, a, b, random.nextRandom()),
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }
}

extension Glados3WidgetTest<First, Second, Third> on Glados3<First, Second, Third> {
  @isTest
  void testWidgets(
    String description,
    WidgetTester3Callback body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    Glados(
      any.combine3(
        firstGenerator,
        secondGenerator,
        thirdGenerator,
        (First a, Second b, Third c) => [a, b, c],
      ),
    ).testWidgets(
      description,
      (tester, input) => body(tester, input[0] as First, input[1] as Second, input[2] as Third),
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }

  @isTest
  void testWidgetsWithRandom(
    String description,
    WidgetTester3CallbackWithRandom body, {
    bool? skip,
    test_package.Timeout? timeout,
    bool semanticsEnabled = true,
    test_package.TestVariant<Object?> variant = const test_package.DefaultTestVariant(),
    dynamic tags,
  }) {
    final random = explore.random.nextRandom();
    testWidgets(
      description,
      (tester, a, b, c) => body(tester, a, b, c, random.nextRandom()),
      skip: skip,
      timeout: timeout,
      semanticsEnabled: semanticsEnabled,
      variant: variant,
      tags: tags,
    );
  }
}
