import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';

class FullScreen extends StatefulWidget {
  String imgUrl;
  FullScreen({super.key, required this.imgUrl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> setWallpaperFromFile(
      String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color(0x4960F9).withOpacity(.1),
        content: Text("Downloading Started...")));
    FileDownloader.downloadFile(
      url: wallpaperUrl,
      onDownloadError: (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
      },
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0x4960F9).withOpacity(.1),
            content: Text("Downloaded Sucessfully"),
            action: SnackBarAction(
              textColor: Color(0x4960F9).withOpacity(1),
              label: "Open",
              onPressed: () {
                OpenFile.open(path);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: 150,
        child: AspectRatio(
          aspectRatio: 208 / 71,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Color(0x4960F9).withOpacity(.3),
                spreadRadius: 4,
                blurRadius: 50,
              )
            ]),
            child: MaterialButton(
              onPressed: () async {
                await setWallpaperFromFile(widget.imgUrl, context);
              },
              splashColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Text(
                    'Download Wallpaper',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Hero(
        tag: widget.imgUrl,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.imgUrl), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
