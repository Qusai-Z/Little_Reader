import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final text = "Microsoft Speech Service Text-to-Speech API";

  void start() async {
    AzureTts.init(
        subscriptionKey: "Product-scoped", region: "ASIA", withLogs: true);
    final voicesResponse = await AzureTts.getAvailableVoices() as VoicesSuccess;

    //Pick a Neural voice
    final voice = voicesResponse.voices
        .where((element) =>
            element.voiceType == "Neural" && element.locale.startsWith("ar-"))
        .toList(growable: false)[0];

    //List all available voices
    print("${voicesResponse.voices}");

    TtsParams params = TtsParams(
        voice: voice,
        audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
        rate: 1.5, // optional prosody rate (default is 1.0)
        text: text);
    final ttsResponse = await AzureTts.getTts(params) as AudioSuccess;

    //Get the audio bytes.
    print("${ttsResponse.audio}");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text(text),
            ElevatedButton(
              onPressed: () {
                start();
              },
              child: const Text('speech'),
            ),
          ],
        ),
      ),
    );
  }
}
