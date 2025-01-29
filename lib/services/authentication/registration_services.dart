import 'package:flutter/cupertino.dart';

import '../../models/User.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();

void registrationHandler(name, phone, usermail, context) {
  var user = User(name, phone, usermail);
  user.createAccount(context);
}
