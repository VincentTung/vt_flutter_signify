import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'drag_input_target.dart';

typedef OnFileChooseDoneCallback = void Function(String filePath);

class FileChooseWidget extends StatefulWidget {
  final String title;
  String filePath ="";
  final OnFileChooseDoneCallback callback;

   FileChooseWidget(this.title, this.callback,this.filePath,{super.key});

  @override
  State<StatefulWidget> createState() => _FileChooseWidgetState();
}

class _FileChooseWidgetState extends State<FileChooseWidget> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.title}：",
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
        DragInputTarget(widget.filePath, (String path) {
          _setPath(path);
        }),
        const SizedBox(
          width: 10,
        ),
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)))),
            backgroundColor: MaterialStateProperty.all(const Color(0xFFD3D3D3)),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: 80,
            child: const Text("浏览"),
          ),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.single.path != null) {
              String path = result.files.single.path!;
              if(path.startsWith("/Volumes/")){
                path = path.replaceFirst("/Volumes/", '');
                path  = path.substring(path.indexOf('/'));
              }
              _setPath(path);
            } else {
              // User canceled the picker
            }
          },
        )
      ],
    );
  }

  void _setPath(String path){
    setState(() {
      widget.filePath = path;
    });
    widget.callback(path);
  }
}
