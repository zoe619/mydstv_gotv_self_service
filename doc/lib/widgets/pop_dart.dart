
import 'package:flutter/material.dart';

class PopUp{
  final Text title;
  final Icon icon;
  final String option;
  const PopUp({this.title, this.icon, this.option});

  static const List<PopUp> pop = <PopUp>[
    PopUp(title: Text('Profile'), icon: const Icon(Icons.account_circle), option: 'profile'),
    PopUp(title: Text('Call Customer Care'), icon: const Icon(Icons.call), option: 'call'),
    PopUp(title: Text('Message Customer Care'), icon: const Icon(Icons.message), option: 'sms'),
    PopUp(title: Text('Logout'), icon: const Icon(Icons.exit_to_app), option: 'log_out'),

  ];

}