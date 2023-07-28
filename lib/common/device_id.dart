import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';

final box = GetStorage();

void getDeviceId()async{
  String? deviceId = await PlatformDeviceId.getDeviceId;
  box.write('deviceId', deviceId);
  if (kDebugMode) {
    print(deviceId);
  }
}