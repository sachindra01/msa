enum Environment {
 
  dev,
  stage,
  prod,
}

class Constants {
  static late Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _config = _Config.debugConstants;
        break;
      case Environment.stage:
        _config = _Config.stageConstants;
        break;
      case Environment.prod:
        _config = _Config.prodConstants;
        break;
    }
  }

  static String get serverUrl {
    return _config[_Config.baseUrl] as String;
  }

  static String get whereAmI {
    return _config[_Config.WHERE_AM_I] as String;
  }
}

class _Config {
 
 
  static const baseUrl = 'BASE_URL';
  // ignore: constant_identifier_names
  static const WHERE_AM_I = 'WHERE_AM_I';

  static Map<String, dynamic> debugConstants = {
    baseUrl: 'https://app.m-sc.jp/stg/backend/public/',
    WHERE_AM_I: 'dev',
  };

  static Map<String, dynamic> stageConstants = {
    baseUrl: 'https://app.m-sc.jp/stg/backend/public/',
    WHERE_AM_I: 'stage',
  };

  static Map<String, dynamic> prodConstants = {
    baseUrl: 'https://app.m-sc.jp/live/backend/public/',
    WHERE_AM_I: 'production'
  };
}
