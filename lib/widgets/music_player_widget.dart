import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/views/home/music_page_manager.dart';

class Player extends StatefulWidget {
  const Player({ Key? key }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // final RadioController _rcon = Get.put(RadioController());
  final PageManagerController _pageManager = Get.find();
  // final ValueNotifier<PlayBackSpeed> _selectedItem =  ValueNotifier<PlayBackSpeed>(PlayBackSpeed.standard);

  var speed = "標準".obs;
  
  playing() {
    _pageManager.play();
    _pageManager.isPlaying.value = true;
  }

  pause() {
    _pageManager.pause();
      _pageManager.isPlaying.value = false;
  }

  @override
  void initState() {
    // _rcon.getRadioDetail(7);
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Obx((() =>  
      SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible:  (_pageManager.isVisible.value == true) ? true : false,
                child: Container(
                  color: primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _pageManager.radioTitle.toString(),
                          style: audioTitleStyle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: kToolbarHeight*1.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ValueListenableBuilder<ButtonState>(
                                
                                valueListenable: _pageManager.buttonNotifier,
                                builder: (_, value, __) {
                                  switch (value) {
                                    case ButtonState.loading:
                                      return const Padding(
                                        padding:  EdgeInsets.only(left: 10, right: 10),
                                        child:  SizedBox(
                                          height: 12,
                                          width: 12,
                                          child:  CircularProgressIndicator.adaptive(
                                            //backgroundColor: white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                      );
                                    case ButtonState.paused:
                                      return IconButton(
                                        onPressed: () {
                                          setState(() {
                                            playing();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 35,
                                          color: white,
                                        )
                                      );
                                    case ButtonState.playing:
                                      return IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pause();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.pause,
                                          color: white,
                                        )
                                      );
                                  }
                                }
                              ),
                            ),
                            // InkWell(
                            //   onTap: (){
                            //     _pageManager.x();
                            //   }
                            //   ,child: const Icon(Icons.fast_forward)),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 22),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 5,
                                      right: 10,
                                      bottom: 30),
                                  child: ValueListenableBuilder<ProgressBarState>(
                                    valueListenable: _pageManager.progressNotifier,
                                    builder: (_, value, __) {
                                      return ProgressBar(
                                        progressBarColor: red,
                                        baseBarColor: white,
                                        thumbColor: white,
                                        timeLabelLocation:
                                            TimeLabelLocation.sides,
                                        timeLabelPadding: 0,
                                        timeLabelType: TimeLabelType
                                            .remainingTime,
                                        timeLabelTextStyle:
                                            const TextStyle(
                                                color: white,
                                                fontSize: 10),
                                        progress: value.current,
                                        buffered: value.buffered,
                                        total: value.total,
                                        onSeek: _pageManager.seek,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                             PopupMenuButton<int>(
                              //padding: const EdgeInsets.only(top: 5,left: 0,right: 0,bottom: 0),
                              offset: const Offset(120, -180),
                              elevation: 2,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                    
                              itemBuilder: (context) => [
                                
                                PopupMenuItem(
                                  height: 3,
                                  value: 1,
                                  child: const Center(child:  Text("速度",style: TextStyle(color: Colors.grey),)),
                                  onTap: () {
                                  },
                                ),
                                const PopupMenuDivider(
                                  height: 20,
                                ),
                                PopupMenuItem(
                                  height: 3,
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("2x",style: chatDateeStyle,),
                                      Icon(speed.value == '2x' ? Icons.check : null, color: primaryColor,size: 15,)
                                    ],
                                  ),
                                  onTap: () {
                                      _pageManager.setSpeed(2);
                                     
                                      setState(() {
                                        speed.value = "2x";
                                      });
                                                    
                                    // con.updateComment(id, );
                                  },
                                ),
                                const PopupMenuDivider(
                                  height: 20,
                                ),
                                PopupMenuItem(
                                  height: 5,
                                  value: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("1.75x",style: chatDateeStyle,),
                                      Icon(speed.value == '1.75x' ? Icons.check : null, color: primaryColor,size: 15,)
                                    ],
                                  ),
                                  onTap: () {
                                    _pageManager.setSpeed(1.75);
                                   
                                    setState(() {
                                        speed.value = "1.75x";
                                      });
                                  },
                                ),
                                  const PopupMenuDivider(
                                  height: 20,
                                ),
                                PopupMenuItem(
                                  height: 5,
                                  value: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("1.5x",style: chatDateeStyle,),
                                      Icon(speed.value == '1.5x' ? Icons.check : null, color: primaryColor,size: 15,)
                                    ],
                                  ),
                                  onTap: () {
                                    _pageManager.setSpeed(1.5);
                                    setState(() {
                                        speed.value = "1.5x";
                                      });
                                  },
                                ),
                                const PopupMenuDivider(
                                  height: 20,
                                ),
                                PopupMenuItem(
                                  height: 5,
                                  value: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("標準",style: chatDateeStyle,),
                                      Icon(speed.value == '標準' ? Icons.check : null, color: primaryColor,size: 15,)
                                    ],
                                  ),
                                  onTap: () {
                                    _pageManager.setSpeed(1);
                                    setState(() {
                                        speed.value = "標準";
                                      });
                                  },
                                ),
                                
                              ],
                                       
                              icon: const Icon(Icons.settings,color: Colors.white)
                            ),
                          //  InkWell(
                          //    child: const Icon(Icons.settings,color: white,size: 20,),
                          //    onTap: (){
                          //      showDialog(context: context, builder: (_){
                                
                          //       return  Dialog(
                          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //           alignment: Alignment.bottomRight,
                          //           // insetPadding: EdgeInsets.zero,
                          //           // contentPadding: EdgeInsets.zero,
                          //           // titlePadding: EdgeInsets.zero,
                          //           insetPadding:   EdgeInsets.only(left: MediaQuery.of(context).size.width*0.70,bottom: MediaQuery.of(context).size.height*0.08,right: 20),
                                  
                                     
                                  
                          //       );
                          //    });
                          //   },
                             
                          //  ),
                            // speedControllerWidget(context),
                            IconButton(
                              onPressed: () {
                                _pageManager.audioPlayer.stop();
                                _pageManager.init();
                                setState(() {
                                  _pageManager.isPlaying.value = false;
                                  _pageManager.isVisible.value = false;
                                  _pageManager.url.value = '';
                                });
                                
                              },
                              icon: const Icon(
                                Icons.close,
                                color: white,
                              )
                            )
                          ],
                        ),
                      ),
      
                    //  const SizedBox(height: 5,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ));
  }

  // speedControllerWidget(context) {
  //   return PopupMenuButton<PlayBackSpeed>(
  //     icon: const Icon(
  //       Icons.settings,
  //       color: white,
  //     ),
  //     itemBuilder: (BuildContext context) {
  //       return List<PopupMenuEntry<PlayBackSpeed>>.generate(
  //         PlayBackSpeed.values.length,
  //         (index) {
  //           return PopupMenuItem(
  //             value: PlayBackSpeed.values[index],
  //             child: AnimatedBuilder(
  //               animation: _selectedItem,
  //               child: Text(
  //                 PlayBackSpeed.values[index].toString(),
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 24,
  //                 ),
  //               ),
  //               builder: (context, child) {
  //                 return RadioListTile<PlayBackSpeed>(
  //                   title: Text(
  //                     PlayBackSpeed.values[index].toString()
  //                   ),
  //                   value: PlayBackSpeed.values[index],
  //                   activeColor: Colors.blue,
  //                   groupValue: _selectedItem.value,
  //                   onChanged: (value) {
  //                     _selectedItem.value = value!;
  //                   }
  //                 );
  //               },
  //             )
  //           );
  //         }
  //       );
  //     },
  //   );
  // }

}
   
// enum PlayBackSpeed {
//   standard,
//   banana
// }