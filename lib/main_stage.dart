import 'package:msa/flavor_setup/app_config.dart';
import 'package:msa/main.dart';
void main() async {
  Constants.setEnvironment(Environment.stage);
  await initializeApp();
}