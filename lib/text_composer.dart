import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  final Function({String text,File imageFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  TextEditingController _controller = TextEditingController();

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final PickedFile pickedFile = (await  ImagePicker.platform.pickImage(source:  ImageSource.camera)) as PickedFile;
              if (pickedFile == null) return;
              File imageFile = File(pickedFile.path);
              widget.sendMessage(imageFile: imageFile);

              setState(() {
                _isComposing = false;
              });
            },
            icon: Icon(Icons.camera_alt),
          ),
          Expanded(
            child: TextField(
              decoration:
                  InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              controller: _controller,
              onSubmitted: (text) {
                widget.sendMessage(text : text);
                _reset();
              },
            ),
          ),
          IconButton(
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(text :_controller.text);
                      _reset();
                    }
                  : null,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
