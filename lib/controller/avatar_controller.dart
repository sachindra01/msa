// import 'package:get/get.dart';

// import 'package:msa/repository/avatar_repo.dart' as repo;

// class AvatarController extends GetxController {
//   late RxBool isLoading = false.obs;
//   List avatars = [];

//   getAvatar() async {
//     try {
//       isLoading(true);
//       var response = await repo.getAvatar();
//       if (response != null) {
//         avatars = response.data;
//       }
//       print(avatars);
//     } catch (e) {
//       e.toString();
//     } finally {
//       isLoading(false);
//       update();
//     }
//   }
// }
