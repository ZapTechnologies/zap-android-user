import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zap_android_user/widgets/main/queue_card_widget.dart';

import '../../provider/queue_provider.dart';

class QueueList extends StatefulWidget {
  const QueueList({super.key});

  @override
  State<QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QueueProvider>(
      builder: (context, value, child) {
        return value.queues.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "The Queues you join will appear here. Join one to see the magic!",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: ListView(
                  children: [
                    ...value.queues.map((queue) {
                      return QueueCardWidget(queue: queue);
                    }),
                  ],
                ),
              );
      },
    );
  }
}
