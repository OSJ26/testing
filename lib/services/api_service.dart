import 'dart:convert';
import "package:http/http.dart" as http;

class ApiServices {
  static const String baseUrl = "https://api-health-sync.onrender.com/api";

  /*
    * Register Api Function which is register patient
    *  */
  static Future<http.Response> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/register');
    return await http.post(url, headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  /*
    * Here the login function which is called from login screen
    * in this function we make an api call to login user
    * 1. Here Future is used because of http call - in flutter we use future when it's need to make an api call
    * 2. in parameter we passed out json object which is in key , value pair
    * 3. using async await because of the api call
    * 4. finally make an api call using Post  which is convert it to uri and make an api call
    * 5. at last we return the response  which we get from api
    * */
  static Future<http.Response> loginUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  /*
  * This method is for add doctor which is performed by admin
  * 1. here, in parameter we add jwt token to verify that its admin only who can register doctors
  * 2. same as above metohds json object is passed here and then using post we make an api call
  * */
  static Future<http.Response> addDoctor(Map<String, dynamic> data,String token,) async {
    final url = Uri.parse('$baseUrl/admin/add-doctor');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  // 🛠 Forgot password API
  static Future<http.Response> forgotPassword({required String email,required String newPassword,}) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "newPassword": newPassword,
      }),
    );
  }

  static Future<http.Response> bookAppointment({
    required String patientId,
    required String doctorId,
    required String date,
    required String timeSlot,
  }) async {
    final url = Uri.parse('$baseUrl/appointments/book');

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date,
        'timeSlot': timeSlot,
      }),
    );
  }

  static Future<http.Response> rescheduleAppointment(
    String appointmentId,
    String newDate,
    String newTimeSlot,
  ) async {
    final url = Uri.parse('$baseUrl/appointments/reschedule');

    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'appointmentId': appointmentId,
        'newDate': newDate,
        'newTimeSlot': newTimeSlot,
      }),
    );
  }


}

