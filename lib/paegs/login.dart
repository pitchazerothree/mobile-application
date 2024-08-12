//import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/config/internal_config.dart';
import 'package:flutter_application_2/models/request/customer_login_post_req.dart';
import 'package:flutter_application_2/models/response/customersLoginRes.dart';
import 'package:flutter_application_2/paegs/register.dart';
import 'package:flutter_application_2/paegs/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  String url = '';


// Initstate คือ Function ที่ทำงานปิดหน้านี้
// 1.Initstate จะทำงานครั้งเดียวเมื่อเปิดหน้านี้
// 2.มันจะไม่ทำงานเมื่อเราเรียก setState
// 3.มันจะไม่สามารถทำงานเป็น async function ได้

  @override
  void initState() {
  super.initState();
  Configuration.getConfig().then(
    (value){
      log(value['apiEndpoint']);
    },
  ).catchError((err){
    log(err.toString());
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    log('Image double tapped');
                  },
                  child: Image.asset('assets/images/logo.jpeg'),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 210, 0),
                  child: Text('หมายเลขโทรศัพท์'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: phoneNoCtl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 275, 0),
                  child: Text('รหัสผ่าน'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    register();
                  },
                  child: const Text('ลงทะเบียนใหม่'),
                ),
                FilledButton(
                  onPressed: login,
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ],
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  void login() {

    // Call login api
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneNoCtl.text, password: passwordCtl.text);

    http.post(Uri.parse('$API_ENDPOINT/customers/login'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        // Send json string of object model
        body: customerLoginPostRequestToJson(req))
      .then(
        (value){
          // Convert Json String to Object (Model)
          CustomersLoginPostResponse Customer = 
              customersLoginPostResponseFromJson(value.body);

          log(Customer.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowtripPage(idx: Customer.customer.idx),
              ));
          // Convert Json String to Map<String, String
          // var jsonRes = jsonDecode(value.body);
          // log(jsonRes['customer']['email']);

        },
      ).catchError((eee){
        log(eee.toString());
      });

    // String phoneNo = phoneCtl.text;
    // String password = passwordCtl.text;

    //  if (phoneNo == '0812345678' && password == '1234') {
    //   setState(() {
    //     text = ''; // Clear any previous error messages
    //   }); 
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const ShowtripPage(),
    //     ),
    //   );
    // } else {
    //   setState(() {
    //     text = 'หมายเลขโทรศัพท์หรือรหัสผ่านไม่ถูกต้อง';
    //   });
    // }
  }
}
