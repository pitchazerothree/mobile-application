import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/internal_config.dart';
import 'package:flutter_application_2/models/request/customer_post_req.dart';
import 'package:flutter_application_2/models/response/customersLoginRes.dart';
import 'package:flutter_application_2/paegs/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController emailNoCtl = TextEditingController();
  TextEditingController passwordNoCtl = TextEditingController();
  TextEditingController confirmPasswordNoCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('ชื่อ-นามสกุล'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: nameNoCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('หมายเลขโทรศัพท์'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: phoneNoCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('อีเมล์'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: emailNoCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('รหัสผ่าน'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: passwordNoCtl,
                obscureText: true, // Hide password
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text('ยืนยันรหัสผ่าน'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: confirmPasswordNoCtl,
                obscureText: true, // Hide password
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: register,
                    child: const Text('สมัครสมาชิก'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('หากมีบัญชีอยู่แล้ว?'),
                  TextButton(
                    onPressed: login,
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    if (passwordNoCtl.text == confirmPasswordNoCtl.text &&
        nameNoCtl.text.isNotEmpty &&
        phoneNoCtl.text.isNotEmpty &&
        emailNoCtl.text.isNotEmpty &&
        passwordNoCtl.text.isNotEmpty &&
        confirmPasswordNoCtl.text.isNotEmpty) {
      
      CustomerPostReq req = CustomerPostReq(
        fullname: nameNoCtl.text,
        phone: phoneNoCtl.text,
        email: emailNoCtl.text,
        image: "",
        password: passwordNoCtl.text,
      );

      http.post(
        Uri.parse("$API_ENDPOINT/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerPostReqToJson(req),
      ).then((response) {
        log(response.body);

        if (response.statusCode == 200) {
          // Successful registration
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  LoginPage(),
            ),
          );
        } else {
          // Handle error
          log('Registration failed: ${response.statusCode}');
        }
      }).catchError((error) {
        log('Error: $error');
      });
    } else {
      log('Password and Confirm Password do not match');
    }
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  LoginPage(),
      ),
    );
  }
}
