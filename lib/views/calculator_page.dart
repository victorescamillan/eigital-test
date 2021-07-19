import 'package:eigital_test/constants/app_labels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  MainAxisAlignment _numericRowMainAlignment = MainAxisAlignment.center;
  String _display = '0';
  String _operation = '';
  String _strOperator = '';
  double _num1 = 0;
  double _num2 = 0;
  bool _isNewValue = false;
  Operator _selectedOperator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: MediaQuery.of(context).size.width - 85,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(_selectedOperator != null)
                  Text('$_operation', style: TextStyle(letterSpacing: 8, fontSize: 12,),
                    textAlign: TextAlign.right,),
                Text('$_display', style: TextStyle(letterSpacing: 8, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,),
              ],
            )),
        Row(
          mainAxisAlignment: _numericRowMainAlignment,
          children: [
            _genericKey(''),
            _genericKey(''),
            _genericKey('Clear'),
            _genericKey('Back'),
          ],
        ),
        Row(
          mainAxisAlignment: _numericRowMainAlignment,
          children: [
            _numericKey('7'),
            _numericKey('8'),
            _numericKey('9'),
            _operatorKey('x'),
          ],
        ),
        Row(
          mainAxisAlignment: _numericRowMainAlignment,
          children: [
            _numericKey('4'),
            _numericKey('5'),
            _numericKey('6'),
            _operatorKey('/'),
          ],
        ),
        Row(
          mainAxisAlignment: _numericRowMainAlignment,
          children: [
            _numericKey('1'),
            _numericKey('2'),
            _numericKey('3'),
            _operatorKey('+'),
          ],
        ),
        Row(
          mainAxisAlignment: _numericRowMainAlignment,
          children: [
            _operatorKey('='),
            _numericKey('0'),
            _genericKey('.'),
            _operatorKey('-'),
          ],
        )
      ],
    );
  }

  _numericKey(String key) {
    double buttonWidth = MediaQuery.of(context).size.width / 5;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        height: 50,
        width: buttonWidth,
        child: ElevatedButton(onPressed: (){
          setState(() {
            if(_isNewValue){
              _display = '';
              _isNewValue = false;
            }
            if(_display == '' || _display == '0'){
              _display = key;
              _getOperation();
            }
            else{
              _display = _display + key;
              _getOperation();
            }
          });
        }, child: Text('$key')));
  }
  _operatorKey(String operator) {
    double buttonWidth = MediaQuery.of(context).size.width / 5;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        height: 50,
        width: buttonWidth,
        child: ElevatedButton(onPressed: (){
          setState(() {
            _strOperator = operator;
            if(_num1 == 0){
              _num1 = double.parse(_display);
              _isNewValue = true;
            }

            switch(operator){
              case 'x':
                _selectedOperator = Operator.Multiplication;
                break;
              case '/':
                _selectedOperator = Operator.Division;
                break;
              case '+':
                _selectedOperator = Operator.Addition;
                break;
             case '-':
                _selectedOperator = Operator.Subtraction;
                break;
              default:
                if(_num1 == 0){
                  return;
                }
                _num2 = double.parse(_display);
                _calculateTotal();
            }
          });
        }, child: Text('$operator'), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),),);
  }
  _genericKey(String value) {
    double buttonWidth = MediaQuery.of(context).size.width / 5;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        height: 50,
        width: buttonWidth,
        child: value == '' ? ElevatedButton(child: Text('$value')) :
          ElevatedButton(onPressed: (){
            setState(() {
              switch(value.toLowerCase()){
                case '.':
                  if(!_display.contains('.')){
                    _display = _display + '.';
                  }
                  break;
                case 'back':
                  if(_display.length <= 1){
                    _display = '0';
                  }
                  else{
                    _display = _display.substring(0, _display.length - 1);
                    _operation = _operation.substring(0, _operation.length - 1);
                  }
                  break;
                default:
                  _clearValues();
              }
            });
          }, child: Text('$value'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey))));
  }

  void _calculateTotal() {
    setState(() {
      switch(_selectedOperator){
        case Operator.Multiplication:
          _display = (_num1 * _num2).toString();
          break;
        case Operator.Division:
          _display = (_num1 / _num2).toString();
          break;
        case Operator.Addition:
          _display = (_num1 + _num2).toString();
          break;
        case Operator.Subtraction:
          _display = (_num1 - _num2).toString();
          break;
      }
    });
  }

  void _clearValues() {
    _display = '0';
    _operation = '';
    _selectedOperator = null;
    _isNewValue = false;
    _num1 = 0;
    _num2 = 0;
  }

  void _getOperation() {
    if(_num1 != 0){
      _operation = _num1.toString() + ' $_strOperator ' +_display;
      print(_operation);
    }
  }
}

enum Operator {
  Multiplication,
  Addition,
  Division,
  Subtraction,
  Equal
}
