import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/join_queue_services.dart';

class GroupingScreen extends StatefulWidget {
  const GroupingScreen(this.queueIds, {super.key});

  final String queueIds;

  @override
  State<GroupingScreen> createState() => _GroupingScreenState();
}

class _GroupingScreenState extends State<GroupingScreen> {
  final queueCodeController = TextEditingController();
  bool isGroupingEnabled = false;
  int memberCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Use Navigator.pop() instead of pushing to avoid stack buildup
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
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
                    // Constrains TextField to take available space
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: queueCodeController,
                      decoration: const InputDecoration(
                        hintText: "Group?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Switch(
                    value: isGroupingEnabled,
                    onChanged: (value) {
                      setState(() {
                        isGroupingEnabled = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isGroupingEnabled,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pending, size: 30),
                        Text(
                          "No of members",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              memberCount--;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(0),
                              ),
                              // Adjust the radius as needed
                            ),
                            child: Center(
                              child: Text(
                                "-",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30, // Add a height to make it visible
                          width: 1,
                          color: Colors.white12,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              memberCount++;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(14),
                              ),
                              // Adjust the radius as needed
                            ),
                            child: Center(
                              child: Text(
                                "+",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Text(memberCount.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                groupingJoinHandler(widget.queueIds, context, memberCount);
              },
              child: Text("Join Queue"),
            ),
          ],
        ),
      ),
    );
  }
}
