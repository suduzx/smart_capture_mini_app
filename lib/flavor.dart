enum Flavor { dev, devMB, devHCM, uat, live }

class F {
  static Flavor? appFlavor;

  static String get keyCloakUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'http://dev.smartsolutionvn.net:8082';
      case Flavor.devMB:
        return 'https://api-sandbox.mbbank.com.vn/ms';
      case Flavor.devHCM:
        return 'http://dev.smartsolutionvn.net:8082';
      case Flavor.uat:
        return 'https://keycloak-internal-uat.mbbank.com.vn/auth';
      case Flavor.live:
        return 'https://keycloak-internal.mbbank.com.vn/auth';
      default:
        return 'keyCloakUrl';
    }
  }

  static String get keyCloakRealm {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ecm';
      case Flavor.devHCM:
        return 'ecm';
      case Flavor.uat:
        return 'internal';
      case Flavor.live:
        return 'internal';
      default:
        return 'keyCloakRealm';
    }
  }

  static String get keyCloakClientId {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ecm-smart-capture-mobile';
      case Flavor.devMB:
        return 'mymb-frontend-v1';
      case Flavor.devHCM:
        return 'ecm-smart-capture-mobile';
      case Flavor.uat:
        return 'ecm-smart-capture-mobile';
      case Flavor.live:
        return 'mymb-mobile';
      default:
        return 'keyCloakClientId';
    }
  }

  static String get keyCloakClientSecret {
    switch (appFlavor) {
      case Flavor.dev:
        return 'GpDq3EgCHSNgZwUkRCnW2j9U6HEvMu2b';
      case Flavor.devHCM:
        return 'GpDq3EgCHSNgZwUkRCnW2j9U6HEvMu2b';
      case Flavor.uat:
        return 'eYgn3ATGnnfYVSL8byWhfQBpI7JlMjQD';
      case Flavor.live:
        return 'eYgn3ATGnnfYVSL8byWhfQBpI7JlMjQD';
      default:
        return 'keyCloakClientSecret';
    }
  }

  static String get keyCloakGrantType {
    return 'password';
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'http://dev.smartsolutionvn.net:9933';
      case Flavor.devMB:
        return 'https://api-sandbox.mbbank.com.vn/ms';
      case Flavor.devHCM:
        return 'http://dev.smartsolutionvn.net:9933';
      case Flavor.uat:
        return 'http://10.1.27.129:9933';
      case Flavor.live:
        return 'https://api-public.mbbank.com.vn/ms/sscan-rs/v3.0';
      default:
        return 'apiUrl';
    }
  }

  static String get baseMapUrl {
    switch (appFlavor) {
      default:
        return 'https://mapiv2.mapsm.net';
    }
  }
}
