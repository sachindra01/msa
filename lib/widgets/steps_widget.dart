import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

class StepWidget extends StatelessWidget {
  const StepWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.66,
      padding: const EdgeInsets.only(top:20.0,bottom:10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.25,
              child: const Divider(thickness: 1.2)
            )
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: const [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor:white,
                      child: Text("1",style: TextStyle(color: primaryColor)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Text('アカウント登録',style: TextStyle(color: primaryColor,fontSize: 12)),
                  )
                ]
              ),
              Column(
                children: const [
                  CircleAvatar(
                    radius:16,
                    backgroundColor:grey,
                    child: Text("2",style: TextStyle(color: white)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Text('プロフィール登録',style: TextStyle(color: grey,fontSize: 14)),
                  )
                ]
              ),
            ]
          ),
        ],
      ),
    );
  }
}