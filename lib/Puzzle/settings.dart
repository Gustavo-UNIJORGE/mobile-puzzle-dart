import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final puzzle = context.watch<PuzzleController>();

    return Row( /* Game Settings */
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text('${puzzle.rounds} jogadas', textAlign: TextAlign.end,)),
        SizedBox(
          width: 128,
          child: TextButton(
            onPressed: () async => puzzle.changeLevel(context),  
            child: Text('Nível: ${puzzle.level}')
          ) 
        ),
      ]
    );
  }
}
