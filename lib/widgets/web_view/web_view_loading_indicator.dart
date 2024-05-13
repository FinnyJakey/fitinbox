import 'package:flutter/material.dart';

class WebLoadingIndicator extends StatefulWidget {
  const WebLoadingIndicator({super.key, required this.currentProgress});
  final int currentProgress;

  @override
  State<WebLoadingIndicator> createState() => _WebLoadingIndicatorState();
}

class _WebLoadingIndicatorState extends State<WebLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return widget.currentProgress < 100
        ? LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: const Color(0xFFF4F4F4),
            color: Colors.grey,
            value: widget.currentProgress / 100.0,
          )
        : const SizedBox.shrink();
  }
}
