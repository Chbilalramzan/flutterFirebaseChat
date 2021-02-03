import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatId;
  final int index;

  ChatRoomsTile({this.userName, @required this.chatId, this.index});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  final FireStoreMethods fireStoreMethods = FireStoreMethods();
  DataController dataController = DataController();
  QuerySnapshot searchResultSnapshot;
  String chatImageUrl;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getChatImage(widget.userName);
    });
    super.initState();
  }

  getChatImage(String name) async {
    try {
      await fireStoreMethods.searchByName(name).then((snapshot) {
        searchResultSnapshot = snapshot;
      });
      setState(() {});
      chatImageUrl = searchResultSnapshot.docs[0].data()["photoUrl"];
      dataController.setChatImageUrl(chatImageUrl);
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                        chatId: widget.chatId,
                        username: widget.userName,
                        chatImageUrl: dataController.chatImageUrl,
                      )));
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: dataController.chatImageUrl == null ||
                              dataController.chatImageUrl == ""
                          ? AssetImage("assets/avatar.png")
                          : NetworkImage(
                              dataController.chatImageUrl,
                            ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(widget.userName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0, right: 5),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ));
  }
}
