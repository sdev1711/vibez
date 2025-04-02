class StringValidation{
  bool isNameValidate(String value){
    return RegExp(r'^[a-z A-Z]+$').hasMatch(value);
  }
  bool isEmailValidate(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }
  bool isPassValidate(String value) {
    return  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value);
  }
  bool isUserNameValidate(String value) {
    return  RegExp(r'^(?!.*\.\.)(?!.*\.$)[a-z0-9._]{1,30}$').hasMatch(value);
  }
}
