// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/comment_controller.dart';
import 'package:msa/views/pages/member_info_page.dart';
import 'package:msa/widgets/comment_popup_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  const CommentWidget(this.modalContext, this.type, this.itemID, this.commentCount, {Key? key}) : super(key: key);

  final modalContext;
  final String type;
  final int itemID;
  final int commentCount;
  

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final CommentController _con = Get.put(CommentController());
  final  _scrollController = AutoScrollController(
  
  );
  final box = GetStorage();
  var count;
  // var isreply = false;
  var _selectedIndex ;
  late FocusNode myFocusNode;
  var replyVisible = false;
  var maxScrollExtent;

  
  

  @override
  void initState() {
   _con.topic = widget.type;
   _con.itemId = widget.itemID;
   //_scrollController.position.maxScrollExtent;
  
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _con.getComment();
       _scrollController.addListener(() { 
     if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
       _scrollController.jumpTo( _scrollController.position.maxScrollExtent -  2);
     }
   });
    
    });
    
    
  
    _con.txtCon.text = "";
     myFocusNode = FocusNode();
    super.initState();
  }
  void jumptoindex(index,[x]) {
    _scrollController.scrollToIndex(index,preferPosition: x == null 
            ?  AutoScrollPosition.begin 
            : AutoScrollPosition.end).then((_) =>  
    _scrollController.animateTo((
      _scrollController.position.pixels + 80),curve: Curves.ease,duration: const Duration(microseconds: 30)));
  
  }

  @override
  void dispose() {
    _scrollController.removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int userID = box.read('userID');
    var userImg = box.read('userImg');
    return SafeArea(
      child: GestureDetector(
         onTap: () => [
          FocusManager.instance.primaryFocus?.unfocus(),
          
          setState(() {
           _con.isreply.value = false;
           //_menuVisible = false;
          })
        
        ],
        child: Container(
          color: white,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: grey.shade200,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40.0),
                        const Text(
                          'コメント',
                          style: catTitleStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(onPressed: () => Navigator.pop(widget.modalContext, _con.commentCount), 
                          icon: const Icon(Icons.close)),
                        )
                      ],
                    )),
                Expanded(
                  child: GetBuilder(
                    init: CommentController(),
                    builder: (ctx) {
                      var memberType = box.read('memberType');
                      return Obx(() => _con.isLoading.value == true
                          ? Center(
                            child: Center(child: loadingWidget(),),
                          )
                          : (_con.comments.isEmpty)
                              ? const Center(
                                child:  Text("コメントする最初の人になる"),
                              )
                              : ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount:  _selectedIndex == _con.comments.length-1 ? _con.comments.length+1 : _con.comments.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  
                                    return  index == _con.comments.length
                                  ? const SizedBox(height: 80,)
                                  :  AutoScrollTag(
                                      key: ValueKey(index),
                                      controller: _scrollController,
                                      index: index,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         ListTile(
                                              minVerticalPadding: 10,
                                              minLeadingWidth: 2,
                                              leading: InkWell(
                                                onTap: (){
                                                  Get.to(()=>const MemberInfoPage(),arguments: _con.comments[index].user.id);
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(51),
                                                  child: CachedNetworkimage(
                                                    height: 40,
                                                    width: 40,
                                                    imageUrl: _con.comments[index].user.imageUrl.toString(),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                _con.comments[index].user.nickname.toString(),
                                                style: const TextStyle(fontSize: 12,color: catTitleyColor),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start, 
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                                                  child: Container(
                                                    width: MediaQuery.of(ctx).size.width,
                                                    decoration:  BoxDecoration(
                                                      color: _selectedIndex == index && _con.isreply.value
                                                      ? grey.shade400 :const Color.fromARGB(255, 250, 248, 248), 
                                                      borderRadius: const BorderRadius.only(
                                                                  topRight: Radius.circular(15),
                                                                  bottomRight: Radius.circular(15),
                                                                  bottomLeft: Radius.circular(15)
                                                        )),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(
                                                        _con.comments[index].comment,
                                                        maxLines: null,
                                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // _con.comments[index].reply.isBlank ? const SizedBox() :const Text("Reply") ,
                                            //   _con.comments[index].containeKey(Reply()),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      formatDate(_con.comments[index].createdAt) ,
                                                      style: const TextStyle(fontSize: 10, color: Colors.black38),
                                                    ),
                                    
                                                    const SizedBox(width: 5,),
                                                    //Reply Button
                                                  InkWell( onTap: () { 
                                                    //  if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
                  
                                                    //  }
                  
                  
                                                    setState(() {
                                                      _con.parentID = _con.comments[index].id;
                                                      _con.isreply.value = (_selectedIndex == index && _con.isreply.value)? true : false;
                                                      if( _con.comments[index].reply.length > 0  && replyVisible == true){
                                                        jumptoindex(index);
                                                      }
                                
                                                      
                                                      _selectedIndex = index;
                                                        if(_selectedIndex > _con.comments.length/2){
                                                            _scrollController.scrollToIndex(_selectedIndex,preferPosition: AutoScrollPosition.end ).then((value) => 
                                                              _scrollController.animateTo((
                                                                  _scrollController.position.pixels + 80),curve: Curves.ease,duration: const Duration(microseconds: 30)));
                                            
                                                        }
                                                      _con.isreply.value = !_con.isreply.value; 
                                                        if (_con.isreply.value){
                                                        myFocusNode.requestFocus();
                                                        
                                                      } else{
                                                        FocusScope.of(ctx).unfocus();
                                                      } 
                                                      
                                                    });
                                
                                                    
                                                    
                                                  }, 
                                                  child: const Text(' 返信する', style:  TextStyle(fontSize: 10, color: Colors.black38),))
                                                                
                                                  ],
                                                )
                                              ]),
                                              trailing: memberType == 'host' 
                                              ? _con.comments[index].user.id == userID
                                                  ? CommentPopUpWidget(_con, _con.comments[index].id.toString(), _con.comments[index].comment,myFocusNode)
                                                  : CommentDeletePopUp(_con, _con.comments[index].id.toString())
                                              : Visibility(
                                                  visible: _con.comments[index].user.id == userID ? true : false,
                                                  child: CommentPopUpWidget(_con, _con.comments[index].id.toString(), _con.comments[index].comment,myFocusNode),
                                              )
                                          ),
                                        _con.comments[index].reply.isEmpty 
                                        ? const SizedBox() 
                                        : (replyVisible && _selectedIndex == index) 
                                          ? SizedBox(
                                            child: Column(
                                            children: [
                                              ListView.builder(
                                              //  primary: true,
                                                reverse: true,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                              // controller: _scrollController, 
                                                itemCount: _con.comments[index].reply.length ,
                                                itemBuilder: ((context, i) {
                                                  var reply = _con.comments[index].reply[i];
                                                  //_con.parentID = reply.id;
                                                  return Padding(
                                                    padding: const EdgeInsets.only(left: 45),
                                                    child: ListTile(
                                                      // contentPadding: EdgeInsets.zero,
                                                        minLeadingWidth: 2,
                                                        minVerticalPadding: 5.0,
                                                        leading: InkWell(
                                                          onTap: (){
                                                            Get.to(()=>const MemberInfoPage(),arguments: reply.user.id);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(25),
                                                                child: CachedNetworkimage(
                                                                  height: 41,
                                                                  width: 41,
                                                                  imageUrl:  reply.user.imageUrl ?? '',
                                                                ),
                                                              ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          reply.user.nickname.toString(),
                                                          style: titleStyle,
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: const BoxDecoration(
                                                                color: Color.fromARGB(255, 250, 248, 248), 
                                                                  borderRadius:  BorderRadius.only(
                                                                        topRight: Radius.circular(15),
                                                                        bottomRight: Radius.circular(15),
                                                                        bottomLeft: Radius.circular(15)
                                                              )),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Text(
                                                                  reply.comment,
                                                                  maxLines: null,
                                                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        
                                                          Text(
                                                            formatDate(reply.createdAt) ,
                                                            style: const TextStyle(fontSize: 10, color: Colors.black38)
                                                          )
                                                        ]),
                                                          trailing: memberType == 'host' 
                                                            ? reply.user.id == userID
                                                                ? CommentPopUpWidget(_con, reply.id.toString(), reply.comment,myFocusNode)
                                                                : CommentDeletePopUp(_con, reply.id.toString())
                                                            : Visibility(
                                                                visible: reply.user.id == userID ? true : false,
                                                                child: CommentPopUpWidget(_con, reply.id.toString(), reply.comment,myFocusNode),
                                                            )
                                                    ),
                                                  );
                                              } )
                                          ),
                            
                                              Visibility(
                                                visible: true,
                                                // visible: WidgetsBinding.instance!.window.viewInsets.bottom == 0.0,
                                                child: SizedBox(
                                                width: MediaQuery.of(ctx).size.width*0.75,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 30),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(25),
                                                          child: CachedNetworkimage(
                                                            height: 41,
                                                            width: 41,
                                                            imageUrl: userImg ?? '',
                                                          ),
                                                        ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                          onTap: (){
                                                            jumptoindex(index,"a");
                                                              setState(() {
                                                                _con.parentID = _con.comments[index].id;
                                                                _con.isreply.value = true;
                                                                myFocusNode.requestFocus();
                                                              });
                                                            },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 15,right: 0,top: 8,bottom: 8),
                                                          child: SizedBox(
                                                          //  width: MediaQuery.of(ctx).size.width*0.1,
                                                            child: TextFormField(                                                             
                                                                controller: _con.isreply.value ? _con.txtCon : _con.replyCon,
                                                                keyboardType: TextInputType.multiline,
                                                                minLines: 1,
                                                                maxLines: 3,
                                                                enabled: false,
                                                                decoration: InputDecoration(
                                                                contentPadding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom:10),
                                                                filled: true,
                                                                fillColor: whiteGrey,
                                                                hintText: '公開コメントを入力',
                                                                hintStyle: chatBoxHintStyle,
                                                                isDense: true,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  borderSide: const BorderSide(
                                                                    color: transparent,
                                                                    width: 1.0
                                                                  )
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  borderSide: const BorderSide(
                                                                    color: transparent,
                                                                    width: 1.0
                                                                  )
                                                                ),
                                                                disabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  borderSide: const BorderSide(
                                                                    color: transparent,
                                                                    width: 1.0
                                                                  )
                                                                ),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                )
                                                            ),
                                                                    
                                                                    ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 30),
                                                    child: InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          replyVisible = false;
                                                          _con.isreply.value = false;
                                                          FocusScope.of(ctx).unfocus();
                                                        });
                                                      },
                                                      child:   Text("閉じる", style: TextStyle(fontSize: 10,color: grey.shade600),),
                                                    ),
                                                  )
                                                    // IconButton(
                                                    //   icon: Icon(
                                                    //     Icons.send,
                                                    //     color: _con.replyCon.text.trim() == "" ? grey : primaryColor,
                                                    //   ),
                                                    //   onPressed: () {
                                                    //     isreply = true;
                                                    //     _con.parentID = _con.comments[index].id;
                                                    //     _con.comment = _con.replyCon.text;
                                                    //     _con.itemID = widget.itemID;
                                                    //     _con.type = widget.type;
                                                    //     if(isreply = true){
                                                    //       _con.comment = _con.replyCon.text;
                                                    //       _con.replyComment().then((value){
                                                    //         setState(() {
                                                    //           isreply = false;
                                                    //           _con.replyCon.clear();
                                                    //         });
                                                    //       });
                                                    //     } 
                                                    //     //   if (_con.replyCon.text.trim() != "") {
                                                    //     //           _con.comment = _con.replyCon.text;
                                                    //     //           _con.replyComment().then((value){
                                                    //     //             setState(() {
                                                    //     //               isreply = false;
                                                    //     //             });
                                                    //     //           });                          
                                                    //     // } 
                                                    //     FocusScope.of(ctx).unfocus();
                                              
                                                    //   },
                                                    // )
                                                  ],
                                                )),
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                        children: [
                                          Padding(
                                          padding: const EdgeInsets.only(left: 45),
                                          child: ListTile(
                                            // contentPadding: EdgeInsets.zero,
                                              minLeadingWidth: 2,
                                              minVerticalPadding: 5.0,
                                              leading: InkWell(
                                                onTap: (){
                                                  Get.to(()=>const MemberInfoPage(),arguments: _con.comments[index].reply[0].user.id);
                                                },
                                                child: Padding(
                                                      padding: const EdgeInsets.only(left: 15),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(25),
                                                          child: CachedNetworkimage(
                                                            height: 41,
                                                            width: 41,
                                                            imageUrl: _con.comments[index].reply[0].user.imageUrl ?? '',
                                                          ),
                                                        ),
                                                    ),
                                                // child: CircleAvatar(
                                                //   radius: 20.0,
                                                //   child: ClipRRect(
                                                //     borderRadius: BorderRadius.circular(20),
                                                //     child: FadeInImage(
                                                //       image: NetworkImage(_con.comments[index].reply[0].user.imageUrl.toString()),
                                                //       placeholder: const AssetImage('assets/images/logo.png'),
                                                //     ),
                                                //   ),
                                                // ),
                                              ),
                                              title: Text(
                                                _con.comments[index].reply[0].user.nickname.toString(),
                                                style: titleStyle,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                  child: Container(
                                                    width: MediaQuery.of(ctx).size.width,
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromARGB(255, 250, 248, 248), 
                                                        borderRadius:  BorderRadius.only(
                                                              topRight: Radius.circular(15),
                                                              bottomRight: Radius.circular(15),
                                                              bottomLeft: Radius.circular(15)
                                                    )),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(
                                                        _con.comments[index].reply[0].comment,
                                                        maxLines: null,
                                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              
                                                Text(
                                                  formatDate(_con.comments[index].reply[0].createdAt) ,
                                                  style: const TextStyle(fontSize: 10, color: Colors.black38)
                                                )
                                              ]),
                                                  trailing: memberType == 'host' 
                                                    ? _con.comments[index].reply[0].user.id == userID
                                                        ? CommentPopUpWidget(_con, _con.comments[index].reply[0].id.toString(), _con.comments[index].reply[0].comment,myFocusNode)
                                                        : CommentDeletePopUp(_con, _con.comments[index].reply[0].id.toString())
                                                    : Visibility(
                                                        visible: _con.comments[index].reply[0].user.id == userID ? true : false,
                                                        child: CommentPopUpWidget(_con, _con.comments[index].reply[0].id.toString(), _con.comments[index].reply[0].comment,myFocusNode),
                                                    ) 
                                          ),
                                        ), 
                                          Visibility(
                                            visible: _con.comments[index].reply.length > 1 ,
                                            child: InkWell(
                                                  onTap: (){
                                                    if(_con.isreply.value){
                                                      jumptoindex(index);
                                                    }
                                                    setState(() {
                                                      replyVisible = true;
                                                      _selectedIndex = index;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 50,top: 10, bottom: 10),
                                                    child: Text("見る "+ (_con.comments[index].reply.length-1).toString()+ " もっと 返信する",
                                                    style: const TextStyle(fontSize: 12, color: black),),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )      
                                ],
                              ),
                            );
                        },
                      ));
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: white,
                      // boxShadow: kElevationToShadow[4],
                    ),
                     padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: double.infinity),
                      child: SizedBox(
                          
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20,right: 10,bottom: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(51),
                                    child: CachedNetworkimage(
                                      height: 35,
                                      width: 35,
                                      imageUrl: userImg ?? '',
                                    ),
                                  ),
                              ),
                              Flexible(
                                  
                                child: SizedBox(
                                  // height: 50.0,
                                  child: ConstrainedBox(
                                     constraints: const BoxConstraints(minWidth: double.infinity),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: TextFormField(
                                          controller: _con.txtCon,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 4,
                                          focusNode: myFocusNode,
                                          
                                         decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom:10),
                                          filled: true,
                                          fillColor: whiteGrey,
                                          hintText: '公開コメントを入力',
                                          hintStyle: chatBoxHintStyle,
                                          isDense: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: const BorderSide(
                                              color: transparent,
                                              width: 1.0
                                            )
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              borderSide: const BorderSide(
                                                color: transparent,
                                                width: 1.0
                                              )
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: transparent,
                                            width: 1.0
                                          )
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0), )
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.only(bottom: 4),
                                icon: Icon(
                                  Icons.send,
                                  color: _con.txtCon.text.trim() == "" ? grey : primaryColor,
                                ),
                                onPressed: () {
                                  
                                  _con.comment = _con.txtCon.text;
                                  _con.itemID = widget.itemID;
                                  _con.type = widget.type;
                                    if (_con.txtCon.text.trim() != "") {
                                      //If  Reply
                                    _con.isreply.value 
                                          ? {
                                            _con.comment = _con.txtCon.text,
                                            _con.replyComment().then((value){
                                              
                                                if(_selectedIndex > 10 && _selectedIndex == _con.comments.length-1){
    
                                                  Future.delayed(const Duration(milliseconds: 20),()=>  _scrollController.animateTo((
                                                  _scrollController.position.maxScrollExtent - 50),curve: Curves.ease,duration: const Duration(microseconds: 30)));
                                              }
                                              setState(() {
                                                
                                                _con.isreply.value = false;
                                                _selectedIndex = _selectedIndex == _con.comments.length ? _con.comments.length - 1 : _selectedIndex ;
                                              });
                                            
                                            
                                            }),
                                          } 
                                      // If there is Comment Id new comment Else Updating the Current Comment  
                                    : _con.commentId == "" || _con.commentId == null
                                        ? {
                                            setState(() {
                                              count = _con.commentCount == null ? widget.commentCount + 1 : _con.commentCount + 1;
                                            }),
                                            _con.postComment(),
                                          }
                                          : {_con.updateComment(_con.commentId, _con.txtCon.text), 
                                         };
                                  } 
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  formatDate(DateTime date){
    final DateTime time1 = DateTime.parse(date.toString());
   
   timeago.setLocaleMessages('ja', timeago.JaMessages ());
    return timeago.format(time1, locale: 'ja').toString();
  }
}
