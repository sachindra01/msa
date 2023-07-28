import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_client.dart';
import 'package:msa/models/edit_profile.dart';
import 'package:msa/models/bar_graph_model.dart';
import 'package:msa/models/first_login_message.dart';
import 'package:msa/models/login_model.dart';
import 'package:msa/models/memberinfo_model.dart';
import 'package:msa/models/profile_model.dart';
import 'package:msa/models/profile_update_response_model.dart';
import 'package:msa/models/updatepassword_model.dart';
import 'package:msa/widgets/toast_message.dart';
import 'package:msa/models/token_validity_model.dart';

logIn(params) async {
  try {
    var response = await dio.post('api/login', data: params);
    if (response.statusCode == 200) {
      var data = LogInModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

logOut() async {
  try {
    final response = await dio.get(
      'api/logout',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

updatePassword(params) async {
  try {
    var response = await dio.post('api/update-password', data: params);

    if (response.statusCode == 200) {
      var data = UpdatePasswordModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    e.response!.data['message'].forEach((key, value){
      showToastMessage(e.response!.data['message'][key][0]);
    });
  } catch (e) {
    log(e.toString());
  }
}

getUserInfo() async {
  try {
    final response = await dio.get(
      'api/profile',
    );

    if (response.statusCode == 200) {
      final data = Profile.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

getBarInfo() async {
  try {
    final response = await dio.get(
      'api/member-report/graph-data?year=2022',
    );

    if (response.statusCode == 200) {
      final data = BarGraphModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
  } catch (e) {
    log(e.toString());
  }
}

updateUserInfo(params) async {
  try {
    var response = await dio.post('api/profile-update', data: params);
    if (response.statusCode == 200) {
      var data = ProfileUpdateResponseModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

getMemberInfo(id) async {
  try {
    var response = await dio.get(
      'api/member-info/$id',
    );

    if (response.statusCode == 200) {
      var data = MemberInfoModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

updateMemberInfo(params) async {
  try {
    var response = await dio.post('api/member-update', data: params);

    if (response.statusCode == 200) {
      final data = EditProfileModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

checkToken() async {
  try {
    var response = await dio.get('api/check-token-validity');
    if (response.statusCode == 200) {
      final data = TokenValidityModel.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

notificationShiftDay() async {
  try {
    var response = await dio.post('api/member-report/notification-shift-day');
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

notificationShiftMonth() async {
  try {
    var response = await dio.post('api/member-report/notification-shift-month');
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

resetPassword(params) async {
  try {
    var response = await dio.post(
      'api/reset-password', 
      data: params
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

verifyResetPassword(params) async {
  try {
    var response = await dio.post(
      'api/verify-reset-password', 
      data: params
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

changePassword(params) async {
  try {
    var response = await dio.post(
      'api/change-password', 
      data: params
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}

firstLoginMessage()async{
  try {
    var response = await dio.get(
      'api/first-login-message', 
    );
    if (response.statusCode == 200) {
      var data = FirstLoginMessage.fromJson(response.data);
      return data;
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.message);
    showToastMessage(e.response!.data['message']);
  } catch (e) {
    log(e.toString());
  }
}