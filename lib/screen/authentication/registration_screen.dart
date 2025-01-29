import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/authentication/registration_services.dart';
import '../../widgets/inputs/registration_inputs.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Begin Here.",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    DataField(
                      text: "Name",
                      controller: nameController,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    DataField(
                      text: "Email Address",
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    DataField(
                      text: "Phone No.",
                      controller: phoneController,
                      inputType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    registrationHandler(
                      nameController.text,
                      phoneController.text,
                      emailController.text,
                      context,
                    );
                  },
                  child: const Text("Create Account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
