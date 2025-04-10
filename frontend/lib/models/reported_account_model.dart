import 'package:flutter/material.dart';

class AccountModel {
  String name;

  AccountModel({
    required this.name,
  });

  static List<AccountModel> getAccountModel() {
    List<AccountModel> account =[];

    account.add(
      AccountModel(
        name: 'Peng'
      )
    );

    return account;
  }
}