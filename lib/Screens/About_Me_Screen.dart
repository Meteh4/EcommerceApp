import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? appVersion;

  Future<void> infoVersion() async {
    setState(() {
    });
  }

  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            IconlyBold.arrow_left_2,
            color: Colors.white,
            size: 20,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        title: Text(
          'about'.tr,
          style: context.theme.primaryTextTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 20, 19, 26),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Shoptraly',
                  style: context.theme.primaryTextTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 15),
                const SizedBox(
                  width: 320,
                ),
                MaterialButton(
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    final Uri url =
                    Uri.parse('https://github.com/Meteh4');

                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Text(
                    'GitHub',
                    style: context.theme.primaryTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: Text(
                '${'author'.tr} Metehan Soydan',
                style: context.theme.primaryTextTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}