
import 'package:flutter/material.dart';

Future<int?> showLevelDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nível de Dificuldade', style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Escolha o nível de dificuldade:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 2),
            child: Text('Fácil (2x2)')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 3), 
            child: Text('Médio (3x3)')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 4),
            child: Text('Difícil (4x4)')
          ),
        ]
      );
    }
  );
}

Future<bool> showShuffleDialog(BuildContext context) async {
  return await showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Tem certeza que quer Embaralhar?', style: TextStyle(
          fontWeight: FontWeight.bold,
        )),
        content: const Text('Seu progresso e tempo será perdido.'),
        actions: [
          TextButton (
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar')
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