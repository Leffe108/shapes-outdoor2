import 'package:url_launcher/url_launcher.dart';

void showPrivacyPolicy() {
  final uri = Uri.parse(
    'https://junctioneer.net/shapes-outdoor2/privacy-policy/',
  );
  launchUrl(uri, mode: LaunchMode.inAppWebView);
}
