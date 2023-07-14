import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailFormPage extends StatefulWidget {
  const EmailFormPage({super.key});

  @override
  State<EmailFormPage> createState() => _EmailFormPageState();
}

class _EmailFormPageState extends State<EmailFormPage> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _formfield,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email,
                  size: 100,
                ),
                const Text("이메일을 기입해 주세요"),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "이메일을 입력해 주세요";
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return "이메일의 형식이 다릅니다.";
                      }
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (_formfield.currentState!.validate()) {
                      logger.d("Success");
                      logger.d(emailController.text);
                      Get.back(result: emailController.text);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                        child: Text(
                          "회원가입",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
