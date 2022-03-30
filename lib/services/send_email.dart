import 'dart:convert';
import 'package:http/http.dart' as http;

Future sendEmail(
    String name, String email, String message, String subject) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_a324stt';
  const templateId = 'template_ryyzmpb';
  const userId = 'RCB0a_MPbJTGYW9U_';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'subject': email,
          'message': message
        }
      }));
  return response;
}
