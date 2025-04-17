import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_list_provider.dart';

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
    await ref.read(userListProvider.notifier).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListProvider);

    return Scaffold(
      appBar: appBar(),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          :ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
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
                users[index].studentId,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // ban
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
    ),
    );
  }
  
  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFFF9000),
      title: Text(
        "Ban Account", 
        style: TextStyle(
          fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }

}