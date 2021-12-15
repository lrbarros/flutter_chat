import 'package:flutter/material.dart';


class ChatMessage extends StatelessWidget {

  ChatMessage(this.data,this.mine);

  final Map<String,dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        children: [
          !mine?
          Padding(padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(backgroundImage: NetworkImage(data['senderPhotoUrl']),)

          ):Container(),

          Expanded(child: Column(
            crossAxisAlignment: mine ? CrossAxisAlignment.end :CrossAxisAlignment.start,
            children: [
              if(data['imageUrl'] != null)
                Image.network(data['imageUrl'],width: 250,)
              else
                Text(data['text'],
                textAlign: mine? TextAlign.end:TextAlign.start,),
              Text(data['senderName'],style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),)

            ],
          )),
          mine?
          Padding(padding: EdgeInsets.only(left: 16),
              child: CircleAvatar(backgroundImage: NetworkImage(data['senderPhotoUrl']),)

          ):Container(),
        ],
      ),
    );
  }
}
