import 'package:flutter/material.dart';
import 'package:frontend/models/reported_account_model.dart';

class BanPage extends StatefulWidget {
  const BanPage({super.key});

  @override
  State<BanPage> createState() => _BanPageState();
}

class _BanPageState extends State<BanPage> {
  List<AccountModel> accounts =[];

  void _getAccount() {
    accounts = AccountModel.getAccountModel();
  }

  @override
  Widget build(BuildContext context) {
    _getAccount();
    return Scaffold(
      appBar: appBar(),
      body: banList(),
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

    ListView banList() {
    return ListView.builder(
      itemCount: accounts.length,
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
                accounts[index].name,
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
    );
  }
}