import 'package:flutter/material.dart';

import '../../services/join_queue_services.dart';

class JoinQueueScreen extends StatefulWidget {
  const JoinQueueScreen({super.key});

  @override
  State<JoinQueueScreen> createState() => _JoinQueueScreenState();
}

class _JoinQueueScreenState extends State<JoinQueueScreen> {
  final queueCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: queueCodeController,
                      decoration: const InputDecoration(
                        hintText: "Enter Queue Password 'XXXXX'",
                        border: InputBorder.none, // Removes the border
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed:
                  () => joinQueueHandler(queueCodeController.text, context),
              child: const Text("Join Queue"),
            ),
          ],
        ),
      ),
    );
  }
}
