
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

Future<int?> changeLevelDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      final puzzle = context.watch<PuzzleController>();

      return AlertDialog(
        title: const Text('Nível de Dificuldade', style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Escolha o nível de dificuldade:'),
        actions: [
          TextButton(
            onPressed: (puzzle.board.level == 2) ? null : () => Navigator.pop(context, 2),
            child: Text('Fácil (2x2)')
          ),
          TextButton(
            onPressed: (puzzle.board.level == 3) ? null : () => Navigator.pop(context, 3), 
            child: Text('Médio (3x3)')
          ),
          TextButton(
            onPressed: (puzzle.board.level == 4) ? null : () => Navigator.pop(context, 4),
            child: Text('Difícil (4x4)')
          ),
        ],
      );
    }
  );
}

Future<bool?> alertShuffleDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Deseja Embaralhar?', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),
        content: 
          const SingleChildScrollView(
            child: Text('Tem certeza que deseja embaralhar as peças? Todo seu progresso e tempo será perdido.')
          ),
        actions: [
          TextButton (
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar', style: TextStyle(color: Colors.redAccent),)
          ),
          TextButton (
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar')
          )
        ] 
      );
    }
  );
}

Future<bool> congratulationsDialog(BuildContext context) async {
  return await showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Voce venceu!', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),
        content: 
          const SingleChildScrollView(
            child: Text('Deseja jogar novamente?')
          ),
        actions: [
          TextButton (
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar')
          ),
        ] 
      );
    }
  );
}