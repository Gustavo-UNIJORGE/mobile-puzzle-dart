import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

class Board extends StatelessWidget {
  const Board({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final puzzle = context.watch<PuzzleController>();
    
    return GridView.count(
      crossAxisCount: puzzle.board.level,
      padding: EdgeInsets.all(64),
      childAspectRatio: 1,
      children: [for (int pos in puzzle.board.positions) 
        ElevatedButton(
          onPressed: 
            puzzle.board.isNeighbourOfEmpty(pos) 
            ? () => puzzle.makeMovement(pos) 
            : null,
          style: ElevatedButton.styleFrom(
            shape: BeveledRectangleBorder(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('$pos', /* Space Index */ 
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: Container(  /* Space Value */
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    /* empty position is here */
                    puzzle.board.values[pos] > 0 ? '${puzzle.board.values[pos]}' : '',
                    style: 
                      TextStyle(
                        fontWeight: FontWeight.bold

                      ),
                    textDirection: TextDirection.rtl,

                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(3.0),
                  )
                )
                
              ),
            ],
          )
        ),
      ]
  );
  
  }
}

class BoardController extends ChangeNotifier {
  int level = 2; // Nível do Puzzle
  int get positionsCount => (level*level); // Tamanho do Puzzle : l = n*n (ex: 3*3 = 9)
  List<int> get positions => List.generate(positionsCount, (i) => i); // [0, ..., (l - 1)]
  List<int> values = []; // Array com os valores embaralhados de 1 a 9. (9 elementos)

  int get emptyPosition => values.indexOf(0);

  bool isNeighbourOfEmpty(position) {    

    bool atTopOfEmpty = (position + level) == emptyPosition; 
    bool atBottomOfEmpty = (position - level) == emptyPosition;
    bool atRightOfEmpty = position == emptyPosition + 1 && position%level != 0;
    bool atLeftOfEmpty = position == emptyPosition - 1  && emptyPosition%level != 0; 

    return (position == emptyPosition 
      || atTopOfEmpty
      || atRightOfEmpty
      || atLeftOfEmpty 
      || atBottomOfEmpty
    );
  }
  
  void generate() {
    /* Preenche o array com valores de (0 + 1) até  */
    values = List.generate(positionsCount - 1, (i) => i + 1)..shuffle()..add(0);
    print(values);
    notifyListeners();
  }

  void swapPositions(positionA, positionB) {
    int valueA = values[positionA];
    int valueB = values[positionB];

    values[positionA] = valueB;
    values[positionB] = valueA;
    notifyListeners();
  }
}