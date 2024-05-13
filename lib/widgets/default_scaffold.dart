import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({super.key, this.backButton = false, this.backgroundColor = Colors.white, this.title, this.body, this.actions});

  final bool backButton;
  final Color backgroundColor;
  final Widget? title;
  final Widget? body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        title: title,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: backButton
            ? CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/svg/icon_backward.svg"),
              )
            : null,
        actions: (actions ?? []) +
            [
              const SizedBox(width: 16),
            ],
      ),
      body: body,
    );
  }
}
