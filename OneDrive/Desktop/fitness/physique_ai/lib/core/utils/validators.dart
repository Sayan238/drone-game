class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name is too short';
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null) return 'Enter a valid number';
    if (age < 13 || age > 80) return 'Age must be between 13 and 80';
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) return 'Height is required';
    final height = double.tryParse(value);
    if (height == null) return 'Enter a valid number';
    if (height < 100 || height > 250) return 'Height must be 100-250 cm';
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) return 'Weight is required';
    final weight = double.tryParse(value);
    if (weight == null) return 'Enter a valid number';
    if (weight < 30 || weight > 300) return 'Weight must be 30-300 kg';
    return null;
  }
}
