import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _expression = "";
  String _output = "0";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  bool _shouldResetOutput = false;

  void _buttonPressed(String btn) {
    setState(() {
      if (_output == "Error" && btn != "AC") {
        _output = "0";
      }

      if (btn == "AC") {
        _expression = "";
        _output = "0";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _shouldResetOutput = false;
      } else if (btn == "BACK") {
        if (_output == "Error" || _shouldResetOutput) {
          _output = "0";
          _shouldResetOutput = false;
        } else if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (btn == "+" || btn == "−" || btn == "×" || btn == "÷") {
        _num1 = double.tryParse(_output) ?? 0;
        _operation = btn;
        _expression = "$_output $btn";
        _shouldResetOutput = true;
      } else if (btn == "=") {
        if (_operation.isNotEmpty) {
          _num2 = double.tryParse(_output) ?? 0;
          _expression = "$_num1 $_operation $_num2 =";
          double result = 0;

          switch (_operation) {
            case "+":
              result = _num1 + _num2;
              break;
            case "−":
              result = _num1 - _num2;
              break;
            case "×":
              result = _num1 * _num2;
              break;
            case "÷":
              if (_num2 == 0) {
                _output = "Error";
                _operation = "";
                _shouldResetOutput = true;
                return;
              }
              result = _num1 / _num2;
              break;
          }

          _output = (result % 1 == 0)
              ? result.toInt().toString()
              : result.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
          _operation = "";
          _shouldResetOutput = true;
        }
      } else if (btn == ".") {
        if (_shouldResetOutput) {
          _output = "0";
          _shouldResetOutput = false;
        } else if (!_output.contains(".")) {
          _output += ".";
        }
      } else {
        if (_output == "0" || _shouldResetOutput) {
          _output = btn;
          _shouldResetOutput = false;
        } else {
          _output += btn;
        }
      }
    });
  }

  Widget _buildKey(String label, {Color? bg, Color? fg, int flex = 1}) {
    final isOperator = ["÷", "×", "−", "+"].contains(label);
    final isEqual = label == "=";
    final isSpecial = ["AC", "BACK"].contains(label);

    final defaultBg = isEqual
        ? Colors.green
        : (isOperator
            ? const Color(0xFFFF9F0A)
            : (isSpecial ? const Color(0xFF2C2F38) : const Color(0xFF1E222B)));

    final defaultFg = (isSpecial && label != "AC")
        ? const Color(0xFFFF453A)
        : (label == "AC" ? const Color(0xFFFF453A) : Colors.white);

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: bg ?? defaultBg,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: InkWell(
            onTap: () => _buttonPressed(label),
            child: Center(
              child: label == "BACK"
                  ? Icon(Icons.backspace_outlined, color: fg ?? defaultFg, size: 24)
                  : Text(
                      label,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: fg ?? defaultFg,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isLandscape ? 600 : 420),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: isLandscape ? 4.0 : 12.0,
              ),
              child: Column(
                children: [
                  // App Title
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isLandscape ? 2.0 : 8.0),
                    child: Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: isLandscape ? 18 : 24,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Display Area (Output Screen)
                  Expanded(
                    flex: isLandscape ? 2 : 3,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: isLandscape ? 4.0 : 12.0,
                      ),
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_expression.isNotEmpty)
                            Text(
                              _expression,
                              style: TextStyle(
                                fontSize: isLandscape ? 16 : 22,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          SizedBox(height: isLandscape ? 2 : 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              _output,
                              style: TextStyle(
                                fontSize: isLandscape ? 48 : 68,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isLandscape ? 4 : 8),

                  // Responsive Keypad (Takes the remaining screen space)
                  Expanded(
                    flex: isLandscape ? 6 : 7,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildKey("AC", flex: 2),
                              _buildKey("BACK"),
                              _buildKey("÷"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildKey("7"),
                              _buildKey("8"),
                              _buildKey("9"),
                              _buildKey("×"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildKey("4"),
                              _buildKey("5"),
                              _buildKey("6"),
                              _buildKey("−"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildKey("1"),
                              _buildKey("2"),
                              _buildKey("3"),
                              _buildKey("+"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildKey("0", flex: 2),
                              _buildKey("."),
                              _buildKey("=", bg: Colors.green),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}