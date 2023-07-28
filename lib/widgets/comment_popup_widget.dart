// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:msa/controller/comment_controller.dart';
import 'package:msa/widgets/custom_dialog.dart';
import 'package:msa/widgets/deletecomment_alert.dart';



//Update Delete
class CommentPopUpWidget extends StatelessWidget {
  CommentPopUpWidget(this.con, this.id, this.comment,this.x, {Key? key})
      : super(key: key);
  CommentController con;
  var id;
  var comment;
  FocusNode x;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(-30, 0),
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),

      itemBuilder: (context) => [
        PopupMenuItem(
          height: 10,
          value: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.create_sharp, color: Colors.black, size: 20),
              Text(
                '編集',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(x);
            con.txtCon.text = comment;
            con.isreply.value = false;
            con.commentId = id;
            Future<void>.delayed(
                const Duration(
                    milliseconds: 500), // OR const Duration(milliseconds: 500),
                () {
              // Get.back();
            });

            // con.updateComment(id, );
          },
        ),
        const PopupMenuDivider(
          height: 20,
        ),
        PopupMenuItem(
          height: 10,
          value: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.delete, color: Colors.black, size: 20),
              Text(
                '削除',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onTap: () {
            Future<void>.delayed(
                const Duration(
                    milliseconds: 500), // OR const Duration(milliseconds: 500),
                () {
              openCustomDialog( DeleteCommentAlert(id: id,), context);
              // con.deleteComment(id);
              
              debugPrint('delete?');
            });
          },
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
      // Icon(Icons.close,color: Colors.white)
    );
  }
}



//delete 
class CommentDeletePopUp extends StatelessWidget {
  CommentDeletePopUp(this.con, this.id,  {Key? key})
      : super(key: key);
  CommentController con;
  var id;


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(-30, 0),
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),

      itemBuilder: (context) => [
        PopupMenuItem(
          height: 10,
          value: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.delete, color: Colors.black, size: 20),
              Text(
                '削除',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onTap: () {
           Future<void>.delayed(
                const Duration(
                    milliseconds: 500), // OR const Duration(milliseconds: 500),
                () {
              openCustomDialog( DeleteCommentAlert(id: id,), context);
              // con.deleteComment(id);
              
              debugPrint('delete?');
            });
          },
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
      // Icon(Icons.close,color: Colors.white)
    );
  }
}
