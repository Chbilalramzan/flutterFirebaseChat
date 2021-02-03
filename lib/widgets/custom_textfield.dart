import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/utils/Constants.dart';

class CustomTextField extends StatefulWidget {
  final Function onChanged;
  final String hint;
  final TextEditingController controller;
  final Function validator;
  final bool obscureText;
  final double height;
  final Function onTap;
  final Widget child, containerChild;

  const CustomTextField(
      {Key key,
      this.onChanged,
      this.hint,
      this.controller,
      this.validator,
      this.obscureText,
      this.height,
      this.onTap,
      this.child,
      this.containerChild})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: widget.height,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Color(kTextFieldColor)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(child: widget.containerChild),
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                obscureText: widget.obscureText,
                validator: widget.validator,
                controller: widget.controller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: widget.child,
            )
          ],
        ),
      ),
    );
  }
}
