import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/Queue.dart';
import '../../provider/queue_provider.dart';

class QueueCardWidget extends StatefulWidget {
  const QueueCardWidget({super.key, required this.queue});

  final Queue queue;

  @override
  State<QueueCardWidget> createState() => _QueueCardWidgetState();
}

class _QueueCardWidgetState extends State<QueueCardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.queue.queueCardWidgetBridge(QueueCardWidgetState);
    widget.queue.findUserIndex();
  }

  String test = "Hello!";

  void QueueCardWidgetState(String action) {
    if (action == "update-index") {
      if (mounted) {
        setState(() {
          test = test;
        });
      }
    } else if (action == "reload-tree") {
      removeQueueCard();
    }
  }

  void removeQueueCard() {
    if (!mounted) return; // Ensure the widget is mounted
    final provider = Provider.of<QueueProvider>(context, listen: false);
    provider.removeQueue(widget.queue.queueId);
  }

  void leaveQueueHandler(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      if (mounted) {
        removeQueueCard();
      }
      widget.queue.queueUserRemoval();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(widget.queue.queueId),
          direction: DismissDirection.endToStart,
          onDismissed: leaveQueueHandler,
          background: Container(
            color: Colors.white,
            child: Center(child: Icon(Icons.read_more, color: Colors.white)),
          ),
          secondaryBackground: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 40),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.queue.queueCardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.queue.name,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${widget.queue.waitTime.toString()} ${widget.queue.waitTime > 1 ? "Mins" : "Min "}",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Location: ${widget.queue.location}",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Landmark: ${widget.queue.landmark}",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Queue ID: ${widget.queue.queueId}",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Visibility(
                    visible: widget.queue.isTimerActive,
                    child: Text(
                      "${widget.queue.waitTime < 9 ? "0" : ""}${widget.queue.waitTime}:${widget.queue.seconds <= 9 ? "0" : ""}${widget.queue.seconds}",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        widget.queue.userQueuePosition.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "out of ${widget.queue.queueMembers.length}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
