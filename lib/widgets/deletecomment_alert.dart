import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/comment_controller.dart';



class DeleteCommentAlert extends StatefulWidget {
  const DeleteCommentAlert({ Key? key, this.id}) : super(key: key);
   // ignore: prefer_typing_uninitialized_variables
   final id;
  

  @override
  State<DeleteCommentAlert> createState() => _DeleteCommentAlertState();
}

class _DeleteCommentAlertState extends State<DeleteCommentAlert> {
  
  
  final CommentController _con = Get.find();




  bool isChecked = false;

  



  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
         width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'コメントを削除します。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width/5,
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(primary: lightgrey,elevation: 1),
                    onPressed: () async {
                     _con.deleteComment(widget.id);
                     
                    },
                    child: const Text(
                      'はい   ',
                      style: TextStyle(color: black,fontSize: 14),
                    ),
                  ),
              ),
              const SizedBox(
                height: 10,
                width: 20,
              ),
              SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width/5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: white,elevation: 0.3),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'あとで ',
                    style: TextStyle(color: black,fontSize: 14),
                  ),
                ),
              ),
              ],),
              
              const SizedBox(
                height: 10,
              ),
            
            
            ],
          ),
        ),
      ],
    );
  }
}
