import 'package:vibez/main.dart';
import 'Flavour/config.dart';

Future<void> main() async{
  await initApp(appFlavour: Production());
}