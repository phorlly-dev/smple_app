import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smple_app/views/forms/index.dart';
import 'package:smple_app/views/widgets/app/topbar.dart';

class WeightCalculator extends StatefulWidget {
  const WeightCalculator({super.key});

  @override
  State<WeightCalculator> createState() => _WeightCalculatorState();
}

class _WeightCalculatorState extends State<WeightCalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  double _bmi = 0.0;
  int _gender = 0; // 0: Male, 1: Female

  final _genderIcons = [Icons.male, Icons.female];

  void _calculateBMI() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    double height = double.tryParse(_heightController.text) ?? 0.0;
    int age = int.tryParse(_ageController.text) ?? 0;

    if (age <= 0 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age.')),
      );
      return;
    }

    if (weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weight and height.')),
      );
      return;
    }

    double bmi;

    // Adjust BMI based on age and gender (example logic)
    if (age < 18) {
      // Hypothetical adjustment for teens
      bmi = weight / ((height / 100) * (height / 100));
      bmi *= (_gender == 0) ? 0.95 : 0.90; // male vs female adjustment
    } else if (age >= 60) {
      // Hypothetical adjustment for seniors
      bmi = weight / ((height / 100) * (height / 100));
      bmi *=
          (_gender == 0) ? 1.05 : 1.00; // males over 60 may have more lean mass
    } else {
      // Standard adult BMI
      bmi = weight / ((height / 100) * (height / 100));
    }

    setState(() {
      _bmi = bmi;
    });
  }

  String _getBMICategory() {
    if (_bmi == 0.0) return 'Please enter your weight and height';

    if (_bmi < 16) return 'Very Severely Underweight';
    if (_bmi < 17) return 'Severely Underweight';
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    if (_bmi < 35) return 'Obese Class I';
    if (_bmi < 40) return 'Obese Class II';

    return 'Obese Class III';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Controls.input(
                    width: 160,
                    field: _ageController,
                    label: 'Age',
                    type: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(width: 10),
                  Controls.input(
                    width: 160,
                    label: 'Height (cm)',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    field: _heightController,
                    type: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildGenderSwitcher(),
                  Controls.switcher(
                    onTap: (index) {
                      setState(() {
                        _gender = index;
                        _calculateBMI();
                      });
                    },
                    value: _gender,
                    listIcons: _genderIcons,
                  ),
                  Controls.input(
                    field: _weightController,
                    label: 'Weight (kg)',
                    type: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your BMI:',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _bmi.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    _bmi < 18.5
                        ? Icons.sentiment_dissatisfied
                        : _bmi < 25
                        ? Icons.sentiment_satisfied
                        : Icons.sentiment_very_dissatisfied,
                    size: 40,
                    color:
                        _bmi < 18.5
                            ? Colors.blue
                            : _bmi < 25
                            ? Colors.green
                            : Colors.red,
                  ),
                ],
              ),
              // const SizedBox(height: 24),
              const Divider(thickness: 2),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Category:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _getBMICategory(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        title: 'Weight Calculator',
      ),
    );
  }
}
