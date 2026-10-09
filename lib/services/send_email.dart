import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> sendEmail(
  String name,
  String email,
  String message,
  String subject,
) {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_a324stt';
  const templateId = 'template_ryyzmpb';
  const userId = 'RCB0a_MPbJTGYW9U_';

  return http.post(
    url,
    headers: const {'Content-Type': 'application/json'},
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'from_name': name,
        'from_email': email,
        'subject': subject,
        'message': message,
      },
    }),
  );
}
