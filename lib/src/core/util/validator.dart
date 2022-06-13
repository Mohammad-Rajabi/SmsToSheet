
class Validators {

  static String? googleSheetUrlValidator(String? value) {
    return emptyValidator(value);
  }

  static String? googleScriptsUrlValidator(String? value) {
    return emptyValidator(value);
  }


  static String? emptyValidator(String? value){
    if(value == null || value.isEmpty){
      return "required";
    }
  }


}