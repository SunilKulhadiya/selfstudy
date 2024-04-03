var this_year = DateTime.now().year.toString();

class AppConfig {
  // static String copyright_text = "@Codewraps " + this_year; //this shows in the splash screen
  // static String app_name = "Umonda"; //this shows in the splash screen
  // static String purchase_code = "a94b130c-1ffa-4a1a-818a-77ff4adb4bfd"; //enter your purchase code for the app from codecanyon
  // //static String purchase_code = ""; //enter your purchase code for the app from codecanyon
  //
  // //Default language config
  // static String default_language = "en";
  // static String mobile_app_code = "en";
  // static bool app_language_rtl = false;
  //
  // //configure this
  // static const bool HTTPS = true;
  //
  static const DOMAIN_PATH = "skandsolution.in"; //localhost

  //do not configure these below
  static const String PACKAGE = "Self_Study";
  static const String API_ENDPATH = "Apis";
  static const String PROTOCOL = "https://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}/";
  static const String BASE_API_URL = "${RAW_BASE_URL}/${PACKAGE}/${API_ENDPATH}/";
  static const String BASE_URL_PACKAGE = "${RAW_BASE_URL}/${PACKAGE}/";
  static const String CAROUSE_BASE_URL = "/Self_Study/Carousel/";
  static const String LOGO_URL = "${RAW_BASE_URL}/Self_Study/Logo_Images/";
  static const String CAROUSE_URL = "${RAW_BASE_URL}${CAROUSE_BASE_URL}";

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
