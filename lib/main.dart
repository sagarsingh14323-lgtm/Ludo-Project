import 'package:flutter/material.dart';

class Utility {
  static Color getColor(int row, int column) {
    //Green
    if ((row == 0 || row == 5) && column <= 5) {
      return Colors.lightGreenAccent;
    }
    if ((column == 0 || column == 5) && row <= 5) {
      return Colors.lightGreenAccent;
    }
    //Yellow
    if ((row == 0 || row == 5) && (column >= 9 && column <= 14)) {
      return Colors.yellowAccent;
    }
    if ((column == 9 || column == 14) && row <= 5) {
      return Colors.yellowAccent;
    }
    //Red
    if ((row == 9 || row == 14) && column <= 5) {
      return Colors.redAccent;
    }
    if ((column == 0 || column == 5) && (row >= 9 && row <= 14)) {
      return Colors.redAccent;
    }
    //Blue
    if ((column == 9 || column == 14) && (row >= 9 && row <= 14)) {
      return Colors.lightBlueAccent;
    }
    if ((row == 9 || row == 14) && (column >= 9 && column <= 14)) {
      return Colors.lightBlueAccent;
    }
    return Colors.transparent;
  }
}
import 'package:flutter/material.dart';
import './gameengine/model/game_state.dart';
import './widgets/gameplay.dart';
import 'package:provider/provider.dart';
import './widgets/dice.dart';
import './gameengine/model/dice_model.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>GameState()),
          ChangeNotifierProvider(create: (context)=>DiceModel()),
        ],
        child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey keyBar = GlobalKey();
  void _onPressed() {
  }
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: Text('Ludo'),
      ),
      body: GamePlay(keyBar,gameState),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: Dice(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
import 'package:flutter/material.dart';
import './ludo_row.dart';

class Board extends StatelessWidget {
  List<List<GlobalKey>> keyRefrences;
  Board(this.keyRefrences);
  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          child: LudoRow(i,keyRefrences[i]),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              bottom:
                  i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Ludo_board.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[..._getRows()],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gameengine/model/dice_model.dart';
class Dice extends StatelessWidget {

  void updateDices(DiceModel dice) {
    for (int i = 0; i < 6; i++) {
    var  duration = 100 + i * 100;
    var future  = Future.delayed(Duration(milliseconds: duration),(){
      dice.generateDiceOne();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceOneImages = [
      "assets/1.png",
      "assets/2.png",
      "assets/3.png",
      "assets/4.png",
      "assets/5.png",
      "assets/6.png",
    ];
    final dice = Provider.of<DiceModel>(context);
    final c = dice.diceOneCount;
    var img = Image.asset(
      _diceOneImages[c - 1],
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );
    return Card(
         elevation: 10,
          child: Container(
            height: 40,
            width: 40,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => updateDices(dice),
                    child: img,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:ludo/gameengine/model/token.dart';
import './board.dart';
import './tokenp.dart';
import '../gameengine/model/game_state.dart';
class GamePlay extends StatefulWidget {
  final GlobalKey keyBar;
  final GameState gameState;
  GamePlay(this.keyBar,this.gameState);
  @override
  _GamePlayState createState() => _GamePlayState();
}
class _GamePlayState extends State<GamePlay> {
    void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) {
      setState(() {
        boardBuild = true;
      });
    });
  }
  callBack(Token token){
    print(token);
  }
  bool boardBuild = false;
  List<double> dimentions = [0, 0, 0, 0];
  final List<List<GlobalKey>> keyRefrences =_getGlobalKeys();
  static List<List<GlobalKey>> _getGlobalKeys() {
    List<List<GlobalKey>> keysMain = [];
    for (int i = 0; i < 15; i++) {
      List<GlobalKey> keys = [];
      for (int j = 0; j < 15; j++) {
        keys.add(GlobalKey());
      }
      keysMain.add(keys);
    }
    return keysMain;
  }
  List<double> _getPosition(int row, int column) {
    var listFrame = List<double>();
    double x;
    double y;
    double w;
    double h;
    if(this.widget.keyBar.currentContext == null) return [0,0,0,0];
    final RenderBox renderBoxBar = this.widget.keyBar.currentContext.findRenderObject();
    final sizeBar = renderBoxBar.size;
    final cellBoxKey = keyRefrences[row][column];
    final RenderBox renderBoxCell =
        cellBoxKey.currentContext.findRenderObject();
    final positionCell = renderBoxCell.localToGlobal(Offset.zero);
    x = positionCell.dx + 1;
    y = (positionCell.dy - sizeBar.height + 1);
    w = renderBoxCell.size.width - 2;
    h = renderBoxCell.size.height - 2;
    listFrame.add(x);
    listFrame.add(y);
    listFrame.add(w);
    listFrame.add(h);
    return listFrame;
  }
    List<Tokenp> _getTokenList(){
    List<Tokenp> widgets = [];
    for(Token token in this.widget.gameState.gameTokens)
    {
      widgets.add(Tokenp(token,_getPosition(token.tokenPosition.row, token.tokenPosition.column)));
    }
    return widgets;
    }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Board(keyRefrences),
         ... _getTokenList()
        ]
      );
  }
}import 'package:flutter/material.dart';
import '../utility.dart';
class LudoRow extends StatelessWidget {
  final int row;
  final List<GlobalKey> keyRow;
  LudoRow(this.row,this.keyRow);
  List<Flexible> _getColumns() {
    List<Flexible> columns = [];
    for (var i = 0; i < 15; i++) {
      columns.add(Flexible(
        key: keyRow[i],
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey),
                right:
                    i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
              ),
              color: Utility.getColor(row, i)//Colors.transparent,
            ),
            //child: Text('${row},${i}'),
          ),
        ),
      ));
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[..._getColumns()],
    );
  }
}
import 'package:flutter/material.dart';
import '../gameengine/model/dice_model.dart';
import '../gameengine/model/game_state.dart';
import '../gameengine/model/token.dart';
import 'package:provider/provider.dart';

class Tokenp extends StatelessWidget {
  final Token token;
  final List<double> dimentions;
  Function(Token)callBack;
  Tokenp(this.token, this.dimentions);
  Color _getcolor() {
    switch (this.token.type) {
      case TokenType.green:
        return Colors.green;
      case TokenType.yellow:
        return Colors.yellow[900];
      case TokenType.blue:
        return Colors.blue[600];
      case TokenType.red:
        return Colors.red;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final dice = Provider.of<DiceModel>(context);
    return AnimatedPositioned(
      duration: Duration(milliseconds: 100),
      left: dimentions[0],
      top: dimentions[1],
      width: dimentions[2],
      height: dimentions[3],
      child: GestureDetector(
           onTap: (){
             gameState.moveToken(token, dice.diceOne);
           },
              child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getcolor(),
                boxShadow: [
                  BoxShadow(
                    color: _getcolor(),
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class GameStateProvider with ChangeNotifier{
  
}class Path{
 static const greenPath = [[6,1],[6,2],[6,3],[6,4],[6,5],
 [5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[0,7]
 ,[0,8],[1,8],[2,8],[3,8],[4,8],[5,8],
 [6,9],[6,10],[6,11],[6,12],[6,13],[6,14],
 [7,14],[8,14],[8,13],[8,12],[8,11],[8,10],[8,9],
 [9,8],[10,8],[11,8],[12,8],[13,8],[14,8],[14,7],[14,6],
 [13,6],[12,6],[11,6],[10,6],[9,6],
 [8,5],[8,4],[8,3],[8,2],[8,1],[8,0],
 [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6]];

  static const yellowPath = [[1,8],[2,8],[3,8],[4,8],[5,8],
 [6,9],[6,10],[6,11],[6,12],[6,13],[6,14],
 [7,14],[8,14],[8,13],[8,12],[8,11],[8,10],[8,9],
 [9,8],[10,8],[11,8],[12,8],[13,8],[14,8],[14,7],[14,6],
 [13,6],[12,6],[11,6],[10,6],[9,6],
 [8,5],[8,4],[8,3],[8,2],[8,1],[8,0],
 [7,0],[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],
 [5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[0,7]
 ,[1,7],[2,7],[3,7],[4,7],[5,7],[6,7]];

   static const bluePath = [[8,13],[8,12],[8,11],[8,10],[8,9],
 [9,8],[10,8],[11,8],[12,8],[13,8],[14,8],[14,7],[14,6],
 [13,6],[12,6],[11,6],[10,6],[9,6],
 [8,5],[8,4],[8,3],[8,2],[8,1],[8,0],
 [7,0],[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],
 [5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[0,7]
 ,[0,8],[1,8],[2,8],[3,8],[4,8],[5,8],
 [6,9],[6,10],[6,11],[6,12],[6,13],[6,14],
 [7,14],[7,13],[7,12],[7,11],[7,10],[7,9],[7,8]];


   static const redPath = [
 [13,6],[12,6],[11,6],[10,6],[9,6],
 [8,5],[8,4],[8,3],[8,2],[8,1],[8,0],
 [7,0],[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],
 [5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[0,7]
 ,[0,8],[1,8],[2,8],[3,8],[4,8],[5,8],
 [6,9],[6,10],[6,11],[6,12],[6,13],[6,14],
 [7,14],[8,14],[8,13],[8,12],[8,11],[8,10],[8,9],
 [9,8],[10,8],[11,8],[12,8],[13,8],[14,8],[14,7],
 [13,7],[12,7],[11,7],[10,7],[9,7],[8,7]];

}
