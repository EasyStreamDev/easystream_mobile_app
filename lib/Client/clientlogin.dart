import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ClientLogin {
  final String accessToken;
  final String refreshToken;
  final List<dynamic> roles;
  final String subscription;

  const ClientLogin({
    required this.accessToken,
    required this.refreshToken,
    required this.roles,
    required this.subscription,
  });

  factory ClientLogin.fromJson(Map<String, dynamic> json) {
    return ClientLogin(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        roles: json['roles'],
        subscription: json['subscription']);
  }
}

Future<ClientLogin?> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://164.132.58.235:5000/auth/login'),
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
    if (response.statusCode == 201) {
    return ClientLogin.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}