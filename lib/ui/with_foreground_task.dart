import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// A widget that prevents the app from closing when the foreground service is running.
/// This widget must be declared above the [Scaffold] widget.
class WithForegroundTask extends StatefulWidget {
  /// A child widget that contains the [Scaffold] widget.
  final Widget child;
  final void Function()? onForeground;

  const WithForegroundTask({
    Key? key,
    required this.child,
    this.onForeground,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WithForegroundTaskState();
}

class _WithForegroundTaskState extends State<WithForegroundTask> {
  Future<bool> _onWillPop() async {
    if (!Navigator.canPop(context) &&
        await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.minimizeApp();
      if (widget.onForeground != null) {
        widget.onForeground!();
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) =>
      WillPopScope(onWillPop: _onWillPop, child: widget.child);
}
