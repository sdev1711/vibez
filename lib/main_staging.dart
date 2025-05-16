import 'Flavour/config.dart';
import 'package:vibez/main.dart';

Future<void> main() async{
  await initApp(appFlavour: Staging());
}