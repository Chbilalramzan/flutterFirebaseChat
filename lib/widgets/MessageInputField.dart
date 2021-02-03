import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/utils/Constants.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;

  const MessageInputField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Color(kTextFieldColor)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
              hintText: "Message ...",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
