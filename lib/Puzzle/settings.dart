import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final puzzle = context.watch<PuzzleController>();

    return Row( 
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 32,
          width: 128,
          child: Text('${puzzle.list.rounds} jogadas', 
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 128,
                child: TextButton(
                    onPressed: () async => puzzle.list.changeLevel(context),  
                    child: Text('Nível: ${puzzle.list.level}')
                  ),
                ), 
            ]
          )
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: puzzle.list.shuffle, 
          icon: Icon(Icons.refresh) 
        ),
      ]
    );
  }
}
