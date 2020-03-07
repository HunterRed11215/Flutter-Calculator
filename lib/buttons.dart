import 'dart:ui';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var test;
  static var userQuestion = '';
  var answer; //used to compute
  var dA = '';
  var displayAnswer = '';  //display final answer
  static List<String> finalElements;
  static var editQuestion = '';

  void _buttonEqual() {
    answer = 0;

    editQuestion = userQuestion;

    for (var i = 0; i < editQuestion.length - 2; i++) {                         //check for Double Negation
      if (editQuestion[i] == '-' && editQuestion[i + 1] == '-') {               // 1--2 -> 1+2
        editQuestion = editQuestion.substring(0, i) +
            '+' +
            editQuestion.substring(i + 2, editQuestion.length);
      }
    }

    for (var i = 1; i < editQuestion.length; i++) {                             //check for double plus
      if (editQuestion[i] == '+' && editQuestion[i - 1] == '+') {               // 1+++2 -> 1+0+0+0+2
        editQuestion = editQuestion.substring(0, i) +
            '0' +
            editQuestion.substring(i, editQuestion.length);
      }
    }

    // +9 becomes 0+9
    if (editQuestion[0] == '+') {
      editQuestion = '0' + editQuestion;
    }

    //if the question starts with a number, add +0, this just helps with the addition functions
    if (startsWithNumber(editQuestion)) {
      editQuestion = '0+' + editQuestion;
    }

    //check if there's a '-' sign, execute subtraction
    for (var i = 0; i < editQuestion.length; i++) {
      if (editQuestion[i] == '-') {
        setState(() {
          _operateSubtraction();
        });
        break;
      }
    }

    //break up numbers separated by +
    finalElements = editQuestion.split("+");

    //this helps with multiplicativeOperation that uses split(x), there needs to be an x
    for ( var i = 0 ; i < finalElements.length ; i++ ) {
      if ( finalElements[i].contains('/') ) {
        finalElements[i] = "1×" + finalElements[i];
      }
    }

    //if there a x symbol, execute multiplication
    for (var i = 0; i < finalElements.length; i++) {
      if (finalElements[i].contains('×')) {
        setState(() {
          _operateMultiplication();
        });
        break;
      }
    }

    //if there exists a '+' sign, execute addition
    for (var i = 0; i < editQuestion.length; i++) {
      if (editQuestion[i] == '+') {
        setState(() {
          _operateAddition();
        });
        break;
      }
    }

    dA =  answer.toStringAsFixed(7);                                            //Standard numbers after decimal point

    //To restrict unnecessary zeros after decimal point.
    List<String> displayA = dA.split('.');
    String last = displayA[1];
    List<String> f = last.split('0');

    f[0] = '.' + f[0];
    displayAnswer = displayA[0] + f[0];

    if ( displayAnswer.endsWith('.') ) {
      displayAnswer = displayAnswer.substring(0,displayAnswer.length-1);
    }

    if (answer.toString().endsWith('.0')) {
      answer = answer.toString().substring(0, answer.toString().length - 2);
    }

  }

  void _operateAddition() {
    for (var i = 0; i < finalElements.length; i++) {
      answer = answer + double.parse(finalElements[i]);
    }
  }

  //place a plus symbol infront of negative sign only if it doesn't have a sign before it
  void _operateSubtraction() {
    for (var i = 1; i < editQuestion.length; i++) {
      if (editQuestion[i] == '-' && !isOperator(editQuestion[i - 1])) {
        editQuestion = editQuestion.substring(0, i) +
            '+' +
            editQuestion.substring(i, editQuestion.length);
        i = i + 2;
      }
    }
  }

  static String _operatePercent(String abc){
    double perResult;

    List<String> perElements = abc.split("%");

    if (perElements[0].contains('/')) {
      perElements[0] = _operateDivision(perElements[0]);
    }

    perResult = (double.parse(perElements[0]) * 100);

    return perResult.toString();
  }

  static String _operateDivision(String abc) {
    double dividedResult;

    List<String> divisiveElements = abc.split("/");
    dividedResult =
        double.parse(divisiveElements[0]) / double.parse(divisiveElements[1]);

    if (divisiveElements.length > 2) {
      for (var k = 2; k < divisiveElements.length; k++) {
        dividedResult = dividedResult / double.parse(divisiveElements[k]);
      }
    }

    return dividedResult.toString();
  }

  void _operateMultiplication() {
    double multipliedResult;

    for (var i = 0; i < finalElements.length; i++) {
      if (finalElements[i].contains("×")) {
        List<String> multiplicativeElements = finalElements[i].split("×");

        //compute division first, then multiplication
        for (var k = 0; k < multiplicativeElements.length; k++) {
          if (multiplicativeElements[k].contains('/') && multiplicativeElements[k].contains('%')) {
            multiplicativeElements[k] =
                _operatePercent(multiplicativeElements[k]);
          } else if (multiplicativeElements[k].contains('/')) {
            multiplicativeElements[k] =
                _operateDivision(multiplicativeElements[k]);
          }
        }

        multipliedResult = double.parse(multiplicativeElements[0]) *
            double.parse(multiplicativeElements[1]);

        if (multiplicativeElements.length > 2) {
          for (var k = 2; k < multiplicativeElements.length; k++) {
            multipliedResult =
                multipliedResult * double.parse(multiplicativeElements[k]);
          }
        }

        finalElements[i] = multipliedResult.toString();
      }
    }
  }

  bool isOperator(String abc) {
    var x = abc[0];

    if (x == '+' || x == '-' || x == '×' || x == '/' || x == '%') {
      return true;
    }

    return false;
  }

  bool startsWithNumber(String abc) {
    var x = abc[0];

    if (x == '0' ||
        x == '1' ||
        x == '2' ||
        x == '3' ||
        x == '4' ||
        x == '5' ||
        x == '6' ||
        x == '7' ||
        x == '8' ||
        x == '9') {
      return true;
    }

    return false;
  }

  void _buttonDel() {
    if (  userQuestion.length == 0 ) {
    }
    else {
      setState(() {
        userQuestion = userQuestion.substring(0,userQuestion.length-1);
      });
    }
  }

  void _buttonDelLP(){
    setState(() {
      userQuestion = '';
    });
  }

  void _buttonClr() {
    setState(() {
      userQuestion = '';
      displayAnswer = '';
    });
  }

  void _button7() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '7';
    });
  }

  void _button8() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '8';
    });
  }

  void _button9() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '9';
    });
  }

  void _button6() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '6';
    });
  }

  void _button5() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '5';
    });
  }

  void _button4() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '4';
    });
  }

  void _button3() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '3';
    });
  }

  void _button2() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '2';
    });
  }

  void _button1() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '1';
    });
  }

  void _button0() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '0';
    });
  }

  void _buttonDecimal() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '.';
    });
  }

  void _buttonPercent() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
      }
      userQuestion = userQuestion + '%';
    });
  }

  void _buttonDivide() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
        userQuestion = answer.toString() + '/';
      } else {
        userQuestion = userQuestion + '/';
      }
    });
  }

  void _buttonMultiply() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
        userQuestion = answer.toString() + '×';
      } else {
        userQuestion = userQuestion + '×';
      }
    });
  }

  void _buttonSubtract() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
        userQuestion = answer.toString() + '-';
      } else {
        userQuestion = userQuestion + '-';
      }
    });
  }

  void _buttonAddition() {
    setState(() {
      if (displayAnswer.toString() != '') {
        _buttonClr();
        userQuestion = answer.toString() + '+';
      } else {
        userQuestion = userQuestion + '+';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF383A54),
      appBar: AppBar(
        title: const Text('C a l c u l a t o r'),
        backgroundColor: Color(0xFF942028),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Color(0xFFD2324D),
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Text(
                        userQuestion,
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ), //Questions
                Expanded(
                  child: Container(
                    color: Color(0xFFFD3A5E),
                    padding: EdgeInsets.only(right: 10, bottom: 20, left: 20),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      displayAnswer.toString(),
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ),
                ), //Answer
              ],
            ),
          ),
          Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonClr,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  'AC',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonDel,
                            onLongPress: _buttonDelLP,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '⌫',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonPercent,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '%',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonDivide,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '÷',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), //AC row
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button7,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '7',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button8,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '8',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button9,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '9',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonMultiply,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '×',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), //7 row
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button4,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button5,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button6,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '6',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonSubtract,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), //4 row
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button1,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button2,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button3,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.pink),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonAddition,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), //1 row
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: _button0,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 30, color: Colors.pink, ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: _buttonDecimal,
                            color: Color(0xFF383A54),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '.',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            onPressed: _buttonEqual,
                            color: Color(0xFFFD3A5E),
                            child: Container(
                              child: Center(
                                child: Text(
                                  '=',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}