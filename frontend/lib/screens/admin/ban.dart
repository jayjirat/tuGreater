import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';

class BanPage extends ConsumerStatefulWidget {
  const BanPage({super.key});


  @override
  BanState createState() => BanState();
}

class BanState extends ConsumerState<BanPage> {

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    await ref.read(userProvider.notifier).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(fetchAllUsersProvider);

    return Scaffold(
      appBar: appBar(),
      body: asyncUsers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xffe6e6e6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.studentId,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirm Deactivation"),
                            content: Text("Are you sure you want to deactivate ${user.studentId}?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text("Confirm"),
                                onPressed: () {
                                  // Call your deactivate function here
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${user.studentId} deactivated")),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Deactivate"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFE95C00),
      title: Text(
        "Ban Account", 
        style: TextStyle(
          fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }

}