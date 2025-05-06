import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/topbar.dart';
import 'package:flutter/services.dart';

class WeightCalculator extends StatefulWidget {
  const WeightCalculator({super.key});

  @override
  State<WeightCalculator> createState() => _WeightCalculatorState();
}

class _WeightCalculatorState extends State<WeightCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  double _bmi = 0.0;
  String _gender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  void _calculateBMI() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    double height = double.tryParse(_heightController.text) ?? 0.0;
    int age = int.tryParse(_ageController.text) ?? 0;

    // Basic validation
    if (age <= 0 || age > 120) {
      // Handle invalid age input (e.g., show an error message)
    }

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
                controller: _weightController,
                label: 'Weight (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
                _buildGenderDropdown(),
                 const SizedBox(height: 16),
              _buildInputField(
                controller: _ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
                 inputFormatters: [FilteringTextInputFormatter.digitsOnly]
                
              ),
              const SizedBox(height: 16),
               _buildInputField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _heightController,
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
              ),
              const SizedBox(height: 16),
              _buildBMICategory(),
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
        border: const OutlineInputBorder(),
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

    return Text('Category: $category', style: const TextStyle(fontSize: 18));
  }
}
