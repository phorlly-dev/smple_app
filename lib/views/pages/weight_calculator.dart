import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/topbar.dart';
import 'package:flutter/services.dart';

class WeightCalculator extends StatefulWidget {
  const WeightCalculator({super.key});

  @override
  State<WeightCalculator> createState() => _WeightCalculatorState();
}

class _WeightCalculatorState extends State<WeightCalculator> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  double _bmi = 0.0;
  String _gender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  void _calculateBMI() {
    double weight = double.tryParse(_weight.text) ?? 0.0;
    double height = double.tryParse(_height.text) ?? 0.0;

    if (weight > 0 && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    } else {
      setState(() {
        _bmi = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputField(
                controller: _weight,
                label: 'Weight (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
                _buildGenderDropdown(),
                 const SizedBox(height: 16),
              _buildInputField(
                controller: _height,
                label: 'Height (cm)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your BMI: ${_bmi.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildBMICategory(),
              // getBMICategory(bmi: _bmi),
            ],
          ),
        ),
        title: 'Weight Calculator',
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        labelText: label,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      items:
          _genderOptions.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _gender = newValue!;
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      labelText: 'Gender',

      ),
    );
  }

  Widget _buildBMICategory() {
    if (_bmi == 0.0) return const SizedBox.shrink();
    String category =
        _bmi < 18.5
            ? 'Underweight'
            : _bmi < 25
            ? 'Normal weight'
            : 'Overweight';
    String category =
        _bmi < 18.5
            ? 'Underweight'
            : _bmi < 25
            ? 'Normal weight'
            : 'Overweight';

    return Text('Category: $category', style: const TextStyle(fontSize: 18));
  }

  // Widget getBMICategory({double bmi = .0}) {
  //   var category = "No data";

  //   // switch (bmi) {
  //   //   case 0:
  //   //     category = "No data";
  //   //   case 16:
  //   //     category = "Severely underweight";
  //   //   case 17:
  //   //     category = "Moderately underweight";
  //   //   case 18.5:
  //   //     category = "Mildly underweight";
  //   //   case 25:
  //   //     category = "Normal";
  //   //   case 30:
  //   //     category = "Overweight";
  //   //   case 35:
  //   //     category = "Obese Class I";
  //   //   case 40:
  //   //     category = "Obese Class II";
  //   //   default:
  //   //     category = "Obese Class III";
  //   // }

  //   if (bmi < 16) category = "Severely underweight";
  //   if (bmi < 17) category = "Moderately underweight";
  //   if (bmi < 18.5) category = "Mildly underweight";
  //   if (bmi < 25) category = "Normal";
  //   if (bmi < 30) category = "Overweight";
  //   if (bmi < 35) category = "Obese Class I";
  //   if (bmi < 40) category = "Obese Class II";

  //   // category = "Obese Class III";

  //   return Text('Category: $category', style: const TextStyle(fontSize: 18));
  // }
}
