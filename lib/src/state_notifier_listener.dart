// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

typedef _Listener<S> = void Function(BuildContext context, S state);

/// - widget that can be used to listen to changes in the state notifier.
/// - [listen] callback is called when the state of [StateNotifier] is changed.
/// - [fireImmidiately] is true [listen] callback will be called immediately upon adding the listener.
class StateNotifierListener<T extends StateNotifier<S>, S>
    extends StatefulWidget {
  const StateNotifierListener({
    Key? key,
    required this.stateNotifier,
    required this.listen,
    required this.builder,
    this.fireImmediately = true,
  }) : super(key: key);
  final T stateNotifier;
  final _Listener listen;
  final bool fireImmediately;
  final WidgetBuilder builder;

  @override
  State<StateNotifierListener> createState() =>
      _StateNotifierListenerState<T, S>();
}

class _StateNotifierListenerState<T extends StateNotifier<S>, S>
    extends State<StateNotifierListener<T, S>> {
  late void Function() _removeListner;
  @override
  void initState() {
    super.initState();

    _removeListner = _addListener();
  }

  RemoveListener _addListener() {
    return widget.stateNotifier.addListener(
      _onStateChanged,
      fireImmediately: widget.fireImmediately,
    );
  }

  @override
  void didUpdateWidget(covariant StateNotifierListener<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasUpdated = oldWidget.stateNotifier != widget.stateNotifier ||
        oldWidget.listen != widget.listen;

    if (hasUpdated) {
      _removeListner();
      _removeListner = widget.stateNotifier.addListener(
        _onStateChanged,
        fireImmediately: widget.fireImmediately,
      );
    }
  }

  void _onStateChanged(S state) {
    return widget.listen(context, state);
  }

  @override
  void dispose() {
    _removeListner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
