import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Text('Version ${snapshot.data!.version}');
        }
        return const Text(' ');
      }),
    );
  }
}
