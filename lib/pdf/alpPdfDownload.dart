import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class ALPCertificateDownload extends StatefulWidget {
  const ALPCertificateDownload(
      {Key? key, required this.certificateData, required this.certificatePath})
      : super(key: key);
  final String certificateData;
  final String certificatePath;

  @override
  State<ALPCertificateDownload> createState() =>
      _ALPCertificateDownloadState(certificateData, certificatePath);
}

class _ALPCertificateDownloadState extends State<ALPCertificateDownload> {
  _ALPCertificateDownloadState(this.cfALPData, this.cfALPPath);
  late String cfALPData;
  late String cfALPPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                // Handle search functionality

                _shareContent();
              },
            ),
          ],
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: const Text("Abnormal Load Permit Form"),
        ),
        body: SfPdfViewer.file(pdfFile()));
  }

  File pdfFile() {
    final url;
    if (Platform.isIOS) {
      return File(cfALPPath + "/" + cfALPData + '.pdf'); // for ios
    } else {
      print("aaaaa " + cfALPPath);
      // File('storage/emulated/0/Download/' + cfData + '.pdf')
      url = File(cfALPPath + "/" + cfALPData + '.pdf');
      return url; // for android
    }
  }

  void _shareContent() {
    Share.shareXFiles([XFile('${cfALPPath}/Abnormal Load Permit.pdf')]);
  }
}
