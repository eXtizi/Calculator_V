import 'package:calculator/calButtons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    // used to check if the result contains a decimal
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }
      return result;
    }

    setState(() {
      if (buttonText == "AC") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "+/-") {
        if (equation[0] != '-') {
          equation = '-$equation';
        } else {
          equation = equation.substring(1);
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '%');

        if (expression.startsWith('√')) {
          expression = '${expression.replaceAll('√', 'sqrt(')})';
        } else if (expression.contains('√')) {
          expression = expression.replaceAll('√', '*sqrt(') + ')';
        }

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (expression.contains('%')) {
            result = doesContainDecimal(result);
          }
          if (result.contains('NaN')) {
            result = "Error";
          } else {
            double tempResult = double.parse(result);
            result = tempResult.toStringAsFixed(5);
            result = doesContainDecimal(result);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          if ("+-×÷%.".contains(buttonText)) {
            equation = equation + buttonText;
          } else {
            equation = buttonText;
          }
        } else {
          // Check if the last character is an operator and the new buttonText is also an operator
          if ("+-×÷%√.".contains(equation[equation.length - 1]) &&
              "+-×÷%√.".contains(buttonText)) {
            // Do nothing if both are operators
          } else {
            // Check if the buttonText is a decimal point and the current number already contains a decimal point
            if (buttonText == '.' &&
                equation.split(RegExp(r'[+\-×÷%√]')).last.contains('.')) {
              // Do nothing if the current number already contains a decimal point
            } else {
              equation = equation + buttonText;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(result,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 80))),
                          const SizedBox(width: 20),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(equation,
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white38,
                                )),
                          ),
                          IconButton(
                            icon: const Icon(Icons.backspace_outlined,
                                color: Colors.orange, size: 30),
                            onPressed: () {
                              buttonPressed("⌫");
                            },
                          ),
                          const SizedBox(width: 20),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('AC', Colors.white10, () => buttonPressed('AC')),
                  calcButton('%', Colors.white10, () => buttonPressed('%')),
                  calcButton('÷', Colors.white10, () => buttonPressed('÷')),
                  calcButton("×", Colors.white10, () => buttonPressed('×')),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('7', Colors.white24, () => buttonPressed('7')),
                  calcButton('8', Colors.white24, () => buttonPressed('8')),
                  calcButton('9', Colors.white24, () => buttonPressed('9')),
                  calcButton('-', Colors.white10, () => buttonPressed('-')),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('4', Colors.white24, () => buttonPressed('4')),
                  calcButton('5', Colors.white24, () => buttonPressed('5')),
                  calcButton('6', Colors.white24, () => buttonPressed('6')),
                  calcButton('+', Colors.white10, () => buttonPressed('+')),
                ],
              ),
              const SizedBox(height: 10),
              // calculator number buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('1', Colors.white24, () => buttonPressed('1')),
                  calcButton('2', Colors.white24, () => buttonPressed('2')),
                  calcButton('3', Colors.white24, () => buttonPressed('3')),
                  calcButton('√', Colors.white10, () => buttonPressed('√')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('+/-', Colors.white24, () => buttonPressed('+/-')),
                  calcButton('0', Colors.white24, () => buttonPressed('0')),
                  calcButton('.', Colors.white24, () => buttonPressed('.')),
                  calcButton('=', Colors.orange, () => buttonPressed('=')),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
