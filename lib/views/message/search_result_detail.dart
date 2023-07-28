import 'package:flutter/material.dart';

class SearchResultDetail extends StatefulWidget {
  final Widget widgetChat;
  const SearchResultDetail({ Key? key ,required this.widgetChat}) : super(key: key);

  @override
  State<SearchResultDetail> createState() => _SearchResultDetailState();
}

class _SearchResultDetailState extends State<SearchResultDetail> {
  
  var messageList = [];

  @override
  Widget build(BuildContext context) {
    return widget.widgetChat;
  }
}