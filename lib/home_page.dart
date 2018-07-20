
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/game_button.dart';
import 'package:tictactoe/custom_dialog.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();

  }


  //初始化
  List<GameButton> doInit(){
    player1 = new List();
    player2 = new List();
    activePlayer = 1;
    
    var gameButton = <GameButton>[
      new GameButton(id:1),
      new GameButton(id:2),
      new GameButton(id:3),
      new GameButton(id:4),
      new GameButton(id:5),
      new GameButton(id:6),
      new GameButton(id:7),
      new GameButton(id:8),
      new GameButton(id:9)
    ];
    return gameButton;
  }

  
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tic Tac Toe"),
      ),
      body: new Column(//在垂直方向上排列子widget的列表
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,//一行的个数
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 9.0,
                  mainAxisSpacing: 9.0),
                  itemCount: buttonsList.length,
                  itemBuilder: (context,i)=>new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: buttonsList[i].enabled ? ()=> playGame(buttonsList[i]) : null,
                      child: new Text(
                          buttonsList[i].text,
                          style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      ),
                      ),
                      color: buttonsList[i].bg,
                      disabledColor: buttonsList[i].bg,
                    ),
                  ),
              ),),//Expanded
          new RaisedButton(
              child: new Text(
                "Reset",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.red,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame,)
        ],
      ),
    );
  }


  playGame(GameButton gb) {
    setState(() {
      if(activePlayer == 1){
        gb.text = 'X';
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      }else{
        gb.text = 'O';
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();

      //没有发现有人胜利
      if(winner == -1){
        //死局
        if(buttonsList.every((p) => p.text != "")){
          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game Tied",
                  "Press the reset button to start again.", resetGame));
        }else{//？？？
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
    
  }

  resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("You Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("AI Won",
                "Press the reset button to start again.", resetGame));
      }
    }

    return winner;
  }

  //AI后手算法
  autoPlay() {

    //玩家在非中心位置,AI占据中间位置
    if(player1.length == 1){
      if(!player1.contains(5)){
        playGame(buttonsList[4]);
        return;
      }else{
        //玩家落子在中心位置,AI需要落子在角位
        var list = new List();
        list.add(0);list.add(2);list.add(6);list.add(8);
        var r = new Random();
        var randIndex = r.nextInt(list.length);
        playGame(buttonsList[list[randIndex]]);
        return;
      }
    }

    //已经下了两个以上，AI的基本攻守
    //row1
    if (player1.contains(1) && player1.contains(2) && !player2.contains(3)) {
      if(!attack())
        playGame(buttonsList[2]);
      return;
    }
    if (player1.contains(1) && player1.contains(3) && !player2.contains(2)) {
      if(!attack())
        playGame(buttonsList[1]);
      return;
    }
    if (player1.contains(2) && player1.contains(3) && !player2.contains(1)) {
      if(!attack())
        playGame(buttonsList[0]);
      return;
    }

    //row2
    if (player1.contains(4) && player1.contains(5) && !player2.contains(6)) {
      if(!attack())
        playGame(buttonsList[5]);
      return;
    }
    if (player1.contains(4) && player1.contains(6) && !player2.contains(5)) {
      if(!attack())
        playGame(buttonsList[4]);
      return;
    }
    if (player1.contains(5) && player1.contains(6) && !player2.contains(4)) {
      if(!attack())
        playGame(buttonsList[3]);
      return;
    }

    //row3
    if (player1.contains(7) && player1.contains(8) && !player2.contains(9)) {
      if(!attack())
        playGame(buttonsList[8]);
      return;
    }
    if (player1.contains(8) && player1.contains(9) && !player2.contains(7)) {
      if(!attack())
        playGame(buttonsList[6]);
      return;
    }
    if (player1.contains(7) && player1.contains(9) && !player2.contains(8)) {
      if(!attack())
        playGame(buttonsList[7]);
      return;
    }

    // col 1
    if (player1.contains(1) && player1.contains(7) && !player2.contains(4)) {
      if(!attack())
        playGame(buttonsList[3]);
      return;
    }
    if (player1.contains(1) && player1.contains(4) && !player2.contains(7)) {
      if(!attack())
        playGame(buttonsList[6]);
      return;
    }
    if (player1.contains(4) && player1.contains(7) && !player2.contains(1)) {
      if(!attack())
        playGame(buttonsList[0]);
      return;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && !player2.contains(8)) {
      if(!attack())
        playGame(buttonsList[7]);
      return;
    }
    if (player1.contains(2) && player1.contains(8) && !player2.contains(5)) {
      if(!attack())
        playGame(buttonsList[5]);
      return;
    }
    if (player1.contains(5) && player1.contains(8) && !player2.contains(2)) {
      if(!attack())
        playGame(buttonsList[1]);
      return;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && !player2.contains(9)) {
      if(!attack())
        playGame(buttonsList[8]);
      return;
    }
    if (player1.contains(6) && player1.contains(9) && !player2.contains(3)) {
      if(!attack())
        playGame(buttonsList[2]);
      return;
    }
    if (player1.contains(3) && player1.contains(9) && !player2.contains(6)) {
      if(!attack())
        playGame(buttonsList[5]);
      return;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && !player2.contains(9)) {
      if(!attack())
        playGame(buttonsList[8]);
      return;
    }
    if (player1.contains(1) && player1.contains(9) && !player2.contains(5)) {
      if(!attack())
        playGame(buttonsList[4]);
      return;
    }
    if (player1.contains(5) && player1.contains(9) && !player2.contains(1)) {
      if(!attack())
        playGame(buttonsList[0]);
      return;
    }

    if (player1.contains(5) && player1.contains(7) && !player2.contains(3)) {
      if(!attack())
        playGame(buttonsList[2]);
      return;
    }
    if (player1.contains(5) && player1.contains(3) && !player2.contains(7)) {
      if(!attack())
        playGame(buttonsList[6]);
      return;
    }
    if (player1.contains(3) && player1.contains(7) && !player2.contains(5)) {
      if(!attack())
        playGame(buttonsList[4]);
      return;
    }

    //有角位占角位
    var concoreList = new List();
    concoreList.add(1);concoreList.add(3);concoreList.add(7);concoreList.add(9);

    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);//1--9
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);//没有被占据的id
      }
    }

    for(var i = 0;i<concoreList.length;i++){
      if(!emptyCells.contains(concoreList[i])){
        concoreList.removeAt(i);
      }
    }
    var r = new Random();
    if(concoreList.length > 0){
      //随机在角位
      var randIndex = r.nextInt(concoreList.length);
      var cellID = concoreList[randIndex];
      int i = buttonsList.indexWhere((p)=> p.id == cellID);
      playGame(buttonsList[i]);
    }else{
      //随机在棱位
      var randIndex = r.nextInt(emptyCells.length);
      var cellID = emptyCells[randIndex];
      int i = buttonsList.indexWhere((p)=> p.id == cellID);
      playGame(buttonsList[i]);
    }
  }

   bool attack(){
    //row1
    if (player2.contains(1) && player2.contains(2)  && !player1.contains(3)) {
      playGame(buttonsList[2]);
      return true;
    }
    if (player2.contains(1) && player2.contains(3)  && !player1.contains(2)) {
      playGame(buttonsList[1]);
      return true;
    }
    if (player2.contains(2) && player2.contains(3)  && !player1.contains(1)) {
      playGame(buttonsList[0]);
      return true;
    }

    //row2
    if (player2.contains(4) && player2.contains(5)  && !player1.contains(6)) {
      playGame(buttonsList[5]);
      return true;
    }
    if (player2.contains(4) && player2.contains(6)  && !player1.contains(5)) {
      playGame(buttonsList[4]);
      return true;
    }
    if (player2.contains(5) && player2.contains(6)  && !player1.contains(4)) {
      playGame(buttonsList[3]);
      return true;
    }

    //row3
    if (player2.contains(7) && player2.contains(8)  && !player1.contains(9)) {
      playGame(buttonsList[8]);
      return true;
    }
    if (player2.contains(8) && player2.contains(9)  && !player1.contains(7)) {
      playGame(buttonsList[6]);
      return true;
    }
    if (player2.contains(7) && player2.contains(9)  && !player1.contains(8)) {
      playGame(buttonsList[7]);
      return true;
    }

    // col 1
    if (player2.contains(1) && player2.contains(7)  && !player1.contains(4)) {
      playGame(buttonsList[3]);
      return true;
    }
    if (player2.contains(1) && player2.contains(4)  && !player1.contains(7)) {
      playGame(buttonsList[6]);
      return true;
    }
    if (player2.contains(4) && player2.contains(7)  && !player1.contains(1)) {
      playGame(buttonsList[0]);
      return true;
    }

    // col 2
    if (player2.contains(2) && player2.contains(5)  && !player1.contains(8)) {
      playGame(buttonsList[7]);
      return true;
    }
    if (player2.contains(2) && player2.contains(8)  && !player1.contains(5)) {
      playGame(buttonsList[5]);
      return true;
    }
    if (player2.contains(5) && player2.contains(8)  && !player1.contains(2)) {
      playGame(buttonsList[0]);
      return true;
    }

    // col 3
    if (player2.contains(3) && player2.contains(6)  && !player1.contains(9)) {
      playGame(buttonsList[8]);
      return true;
    }
    if (player2.contains(6) && player2.contains(9)  && !player1.contains(3)) {
      playGame(buttonsList[2]);
      return true;
    }
    if (player2.contains(3) && player2.contains(9)  && !player1.contains(6)) {
      playGame(buttonsList[5]);
      return true;
    }

    //diagonal
    if (player2.contains(1) && player2.contains(5)  && !player1.contains(9)) {
      playGame(buttonsList[8]);
      return true;
    }
    if (player2.contains(1) && player2.contains(9)  && !player1.contains(5)) {
      playGame(buttonsList[4]);
      return true;
    }
    if (player2.contains(5) && player2.contains(9)  && !player1.contains(1)) {
      playGame(buttonsList[0]);
      return true;
    }

    if (player2.contains(5) && player2.contains(7)  && !player1.contains(3)) {
      playGame(buttonsList[2]);
      return true;
    }
    if (player2.contains(5) && player2.contains(3)  && !player1.contains(7)) {
      playGame(buttonsList[6]);
      return true;
    }
    if (player2.contains(3) && player2.contains(7)  && !player1.contains(5)) {
      playGame(buttonsList[4]);
      return true;
    }
    return false;
  }
}

