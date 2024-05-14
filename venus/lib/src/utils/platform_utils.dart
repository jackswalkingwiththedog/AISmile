import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

abstract class PlatformUtils {
  static String get operatingSystem => _os();
  static String _os() {
    if (UniversalPlatform.isAndroid) {
      return 'android';
    } else if (UniversalPlatform.isIOS) {
      return 'ios';
    } else if (UniversalPlatform.isMacOS) {
      return 'macos';
    } else if (UniversalPlatform.isWindows) {
      return 'windows';
    } else if (UniversalPlatform.isLinux) {
      return 'linux';
    } else if (UniversalPlatform.isFuchsia) {
      return 'fuchsia';
    } else if (UniversalPlatform.isWeb) {
      return 'web';
    } else {
      return 'unknown';
    }
  }

  static bool get isAndroid => UniversalPlatform.isAndroid;
  static bool get isIOS => UniversalPlatform.isIOS;
  static bool get isMacOS => UniversalPlatform.isMacOS;
  static bool get isWindows => UniversalPlatform.isWindows;
  static bool get isLinux => UniversalPlatform.isLinux;
  static bool get isFuchsia => UniversalPlatform.isFuchsia;
  static bool get isWeb => UniversalPlatform.isWeb;
  static bool get isMobileOS => !UniversalPlatform.isDesktop && !kIsWeb;

  static Future<bool> launchUrl(
    String url, {
    ul.LaunchMode mode = ul.LaunchMode.platformDefault,
    ul.WebViewConfiguration webViewConfiguration = const ul.WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    final uri = Uri.parse(url);
    if (await ul.canLaunchUrl(uri)) {
      return ul.launchUrl(
        uri,
        mode: mode,
        webViewConfiguration: webViewConfiguration,
        webOnlyWindowName: webOnlyWindowName,
      );
    } else {
      return Future.value(false);
    }
  }

  static Future<bool> canLaunchUrl(String url) => ul.canLaunchUrl(Uri.parse(url));

  static Future<bool> launchMap({double? lat, double? lon, String? label}) async {
    late Uri uri;
    final latitude = lat ?? 0.0;
    final longitude = lon ?? 0.0;
    if (PlatformUtils.isIOS) {
      final params = {'ll': '$latitude,$longitude'};
      if (label != null) {
        params['q'] = label;
      }
      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      final query = '$latitude,$longitude${label != null ? '($label)' : ''}';
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: <String, dynamic>{'q': query});
    }
    return launchUrl(uri.toString());
  }
}
