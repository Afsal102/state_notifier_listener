import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:state_notifier_listener/state_notifier_listener.dart';

class _TestStateNotfier extends StateNotifier<int> {
  _TestStateNotfier() : super(0);

  void updateCount() {
    state++;
  }
}

// ignore: must_be_immutable
class _TestWidget extends StatelessWidget {
  _TestWidget({
    Key? key,
    required this.stateNotifier,
    this.fireImmediately = true,
  }) : super(key: key);
  final _TestStateNotfier stateNotifier;
  final bool fireImmediately;

  int listenValue = 10;

  @override
  Widget build(BuildContext context) {
    return StateNotifierListener<_TestStateNotfier, int>(
      stateNotifier: stateNotifier,
      fireImmediately: fireImmediately,
      listen: (context, state) {
        listenValue = state;
      },
      builder: (_) => Column(
        children: [
          ElevatedButton(
            onPressed: () {
              stateNotifier.updateCount();
            },
            child: const Text('update'),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('StateNotfierListner', () {
    testWidgets('should listen to state changes immediately', (tester) async {
      final stateNotifier = _TestStateNotfier();
      await tester.pumpPage(_TestWidget(stateNotifier: stateNotifier));
      await tester.pump();

      final widgetFinder = find.byType(_TestWidget);
      _TestWidget widget = tester.widget(widgetFinder);
      expect(stateNotifier.debugState, 0);
      expect(widget.listenValue, 0);

      await tester.tap(find.byType(ElevatedButton));

      widget = tester.widget(widgetFinder);

      expect(stateNotifier.debugState, 1);
      expect(widget.listenValue, 1);

      stateNotifier.dispose();
    });

    testWidgets(
        'should listen to state changes immediately([fireImmediately] set to false)',
        (tester) async {
      final stateNotifier = _TestStateNotfier();
      await tester.pumpPage(_TestWidget(stateNotifier: stateNotifier,fireImmediately: false,));
      await tester.pump();

      final widgetFinder = find.byType(_TestWidget);
      _TestWidget widget = tester.widget(widgetFinder);
      expect(stateNotifier.debugState, 0);
      expect(widget.listenValue, 10);

      await tester.tap(find.byType(ElevatedButton));

      widget = tester.widget(widgetFinder);

      expect(stateNotifier.debugState, 1);
      expect(widget.listenValue, 1);

      stateNotifier.dispose();
    });
  });
}

extension on WidgetTester {
  Future<void> pumpPage(Widget child) async {
    await pumpWidget(MaterialApp(
      home: Scaffold(body: child),
    ));
  }
}
