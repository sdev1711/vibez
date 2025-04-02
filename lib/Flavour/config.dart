class Config {
  Config._();
  static late Flavour appFlavour;
}

abstract class Flavour {
  String get name;
}

class Staging implements Flavour {
  @override
  String get name => "Staging";

}

class Production implements Flavour {
  @override
  String get name => "Production";

}
