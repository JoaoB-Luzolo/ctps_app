import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class CertificateDownload extends StatefulWidget {
  const CertificateDownload(
      {Key? key, required this.certificateData, required this.certificatePath})
      : super(key: key);
  final String certificateData;
  final String certificatePath;

  @override
  State<CertificateDownload> createState() =>
      _CertificateDownloadState(certificateData, certificatePath);
}

class _CertificateDownloadState extends State<CertificateDownload> {
  _CertificateDownloadState(this.cfData, this.cfPath);
  late String cfData;
  late String cfPath;

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
            // Add the navigation action
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
          title: const Text("Cross Border Permit Form"),
        ),
        body: SfPdfViewer.file(pdfFile()));
  }

  File pdfFile() {
    final url;

    if (Platform.isIOS) {
      return File(cfPath + "/" + cfData + '.pdf'); // for ios
    } else {
      print("aaaaa " + cfPath);
      // File('storage/emulated/0/Download/' + cfData + '.pdf')
      url = File(cfPath + "/" + cfData + '.pdf');
      return url; // for android
    }
  }

  void _shareContent() {
    Share.shareXFiles([XFile('${cfPath}/Cross Border Permit.pdf')]);
    // File fileToShare =
    //     pdfFile(); // Get the File with dynamically generated name
    // Share.shareFiles([fileToShare.path]);
  }
}
