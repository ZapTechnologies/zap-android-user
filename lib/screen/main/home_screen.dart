import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../provider/queue_provider.dart';
import '../../widgets/main/queue_list.dart';
import '../join_queue/join_queue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getQueues() async {
    final provider = Provider.of<QueueProvider>(context, listen: false);
    provider.getAllQueues();
    PermissionStatus status = await Permission.notification.status;
    PermissionStatus newStatus = await Permission.notification.request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQueues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: false,
        title: Text(
          "Your Queues",
          style: GoogleFonts.poppins(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinQueueScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: QueueList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JoinQueueScreen()),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
