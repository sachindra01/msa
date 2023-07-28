import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/views/home/radio_detail.dart';
import 'package:msa/views/pages/splash.dart';
import 'package:msa/views/profile/notification_page.dart';
import 'package:msa/widgets/toast_message.dart';
import 'package:msa/widgets/webview_page.dart';
import 'package:rxdart/subjects.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future initializeApp() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'jp.msa.app',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    preloadArtwork: true,
    notificationColor: Colors.white,
    androidShowNotificationBadge: true
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, 
      DeviceOrientation.portraitDown
    ]
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: white,
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const locale = Locale("ja", "JP");

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "MainNavigator");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    notificationInitialization();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  notificationInitialization() async {
    if (Platform.isIOS) {
      iosPermissionHandler();
    }
    _requestPermissions();
    firebaseInitialize();
    String? fcm = await messaging.getToken();
    box.write('fcm',fcm);
    debugPrint('FCM Token => $fcm');
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }

  iosPermissionHandler() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  firebaseInitialize() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.payload;
      // initialRoute = SecondPage.routeName;
    }
    const AndroidInitializationSettings initializationSettingsAndroid =AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      }
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );
    //Also If App is in Foreground
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null || payload != "") {
          dynamic data = json.decode(payload!);
          selectedNotificationPayload = payload;
          selectNotificationSubject.add(payload);
          debugPrint('notification payload: $payload');
          if(data.isNotEmpty){
            notificClickNavigateOnForground(data);
          }else{
            navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationPage()));
          }
        }
      }
    );
    //If App is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      
      if (notification != null && android != null && !kIsWeb) { 
        if (kDebugMode) {
          print(message.data);
        }       
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              notification.hashCode.toString(),
              notification.title.toString(),
              channelDescription: notification.body,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(
              threadIdentifier: notification.body,
              subtitle: notification.title.toString(),
            ),
          ),
          payload: json.encode(message.data),
        );
      }else{
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              notification.hashCode.toString(),
              notification.title.toString(),
              channelDescription: notification.body,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(
              threadIdentifier: notification.body,
              subtitle: notification.title.toString(),
            ),
          ),
          payload: json.encode(message.data),
        );
      }
    });
    //If app is in Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data.isNotEmpty){
        if (kDebugMode) {
          print("BACKGROUND");
        }
        notificClickNavigate(message);
      }else{
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationPage()));
      }
    });
    //If App is Closed/Killed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message!=null){
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        if (notification != null && android != null) {
          Future.delayed(const Duration(seconds: 6), () {
            showToastMessage('navigating');
            notificClickNavigateKilledState(message);
          });
        }
      }
    });
  }
  
  void notificClickNavigateOnForground(message){
    if(message["module_type"]=="radio"){
      if (kDebugMode) {
        print("true id");
      }
      Get.to(()=> RadioDetailPage(data: message,frompage: 'pnfore',));
    }
    else if(message["module_type"]=="blog"){
      Get.to(()=> const WebviewPage(),arguments: [
        message['module_type_id'].toString(),
        'article'
      ]);
    }
    else if(message["module_type"]=="news"){
      Get.to(()=> const WebviewPage(),arguments: [
        message['module_type_id'].toString(),
        'news'
      ]);
    }
    else{
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationPage()));
    }
  }

  void notificClickNavigate(message){
    if(message.data["module_type"]=="radio"){
      if (kDebugMode) {
        print("true id");
      }
      Get.to(()=> RadioDetailPage(data: message,frompage: 'pn',));
    }
    else if(message.data["module_type"]=="blog"){
      Get.to(()=> const WebviewPage(),arguments: [
        message.data['module_type_id'].toString(),
        'article'
      ]);
    }
    else if(message.data["module_type"]=="news"){
      Get.to(()=> const WebviewPage(),arguments: [
        message.data['module_type_id'].toString(),
        'news'
      ]);
    }
    else{
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationPage()));
    }
  }

  void notificClickNavigateKilledState(message)async{
    if(message.data['module_type']=='radio'){
      await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => RadioDetailPage(data: message.data,frompage: 'pn',)));
    }
    else if(message.data['module_type']=='blog'){
      await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => WebviewPage(
        data: [
          message.data['module_type_id'].toString(),
          'article'
        ],
      )));
    }
    else if(message.data['module_type']=='news'){
      await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => WebviewPage(
        data: [
          message.data['module_type_id'].toString(),
          'news'
        ],
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MSC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: MyApp.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        MyApp.locale,
      ],
      home: const SplashPage(),
    );
  }
}
