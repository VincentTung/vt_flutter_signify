import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

typedef OnFileDragDoneCallback = void Function(String filePath);

class DragInputTarget extends StatefulWidget {
  OnFileDragDoneCallback fileDragDoneCallback;

  String filePath = "";

  DragInputTarget(this.filePath, this.fileDragDoneCallback, {Key? key})
      : super(key: key);

  @override
  _DragInputTargetState createState() => _DragInputTargetState();
}

class _DragInputTargetState extends State<DragInputTarget> {
  bool _dragging = false;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500,
        child: DropTarget(
          onDragDone: (detail) {
            setState(() {
              widget.filePath = detail.files.last.path;
              widget.fileDragDoneCallback(widget.filePath);
              controller.text = widget.filePath;
            });
          },
          onDragEntered: (detail) {
            setState(() {
              _dragging = true;
            });
          },
          onDragExited: (detail) {
            setState(() {
              _dragging = false;
            });
          },
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.blueAccent),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
            onChanged: (text) {
              widget.filePath = text;
              widget.fileDragDoneCallback(widget.filePath);
            },
          ),
        ));
  }
}
