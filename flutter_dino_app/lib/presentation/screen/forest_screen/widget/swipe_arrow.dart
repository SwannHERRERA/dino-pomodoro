import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SwipeArrow extends StatelessWidget {
  const SwipeArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: PomodoroTheme.secondary,
          ),
          onPressed: () {
            // Action lorsque la flèche gauche est appuyée
          },
        ),
        Center(
          child: Container(
            child: Text("23 Juillet 2012", style: PomodoroTheme.title4),
          ),
        ),
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowRight,
            color: PomodoroTheme.secondary,
          ),
          onPressed: () {
            // Action lorsque la flèche droite est appuyée
          },
        ),
      ],
    );
  }
}