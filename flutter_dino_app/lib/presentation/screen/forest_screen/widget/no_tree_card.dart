import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class NoTreeCard extends StatelessWidget {
  const NoTreeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PomodoroTheme.secondary,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text("Vous n'avez pas encore planté d'arbre à cette date",
                style: TextStyle(color: PomodoroTheme.yellow, fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
