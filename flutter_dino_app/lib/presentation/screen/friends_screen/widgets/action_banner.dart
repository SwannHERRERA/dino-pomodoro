import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/theme.dart';

class ActionBanner extends StatefulWidget {
  final String body;
  final Function clickOnAction;
  final FaIcon actionIcon;
  final FaIcon startIcon;

  const ActionBanner({
    super.key,
    required this.body,
    required this.clickOnAction,
    required this.actionIcon,
    required this.startIcon,
  });

  @override
  State<ActionBanner> createState() => _ActionBannerState();
}

class _ActionBannerState extends State<ActionBanner> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: PomodoroTheme.secondary,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
    ),
      leading: widget.startIcon,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.body,
            style: PomodoroTheme.title4,
          ),
          GestureDetector(
            onTap: () {
              widget.clickOnAction(widget.body);
            },
            child: widget.actionIcon,
          ),
        ],
      ),
    );
  }
}