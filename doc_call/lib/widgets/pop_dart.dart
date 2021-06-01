
import 'package:flutter/material.dart';

class PopUp
{
  final Text title;
  final Icon icon;
  final String option;
  const PopUp({this.title, this.icon, this.option});

  static const List<PopUp> pop = <PopUp>[
    PopUp(title: Text('Home'), icon: const Icon(Icons.home), option: 'home'),
    PopUp(title: Text('Profile'), icon: const Icon(Icons.account_circle), option: 'profile'),
    PopUp(title: Text('Logout'), icon: const Icon(Icons.exit_to_app), option: 'log_out'),

  ];

}