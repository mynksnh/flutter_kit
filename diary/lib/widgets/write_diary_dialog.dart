import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker_web/image_picker_web.dart';

import '../model/diary.dart';
import '../util/utils.dart';

class WriteDiaryDialog extends StatefulWidget {
  const WriteDiaryDialog({
    Key? key,
    this.selectedDate,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final DateTime? selectedDate;

  @override
  WriteDiaryDialogState createState() => WriteDiaryDialogState();
}

class WriteDiaryDialogState extends State<WriteDiaryDialog> {
  var _buttonText = 'Done';
  Uint8List? _fileBytes;
  Image? _imageWidget;
  String? currId;

  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Text('Discard'),
                    style: TextButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(_buttonText),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.green, width: 1))),
                    onPressed: () {
                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;
                      final dateTime = DateTime.now();
                      final path = '$dateTime';

                      final _fieldsNotEmpty =
                          widget._titleTextController.toString().isNotEmpty &&
                              widget._descriptionTextController.text
                                  .toString()
                                  .isNotEmpty;

                      if (_fieldsNotEmpty) {
                        diaryCollectionReference
                            .add(Diary(
                                    title: widget._titleTextController.text,
                                    entry:
                                        widget._descriptionTextController.text,
                                    author: FirebaseAuth
                                        .instance.currentUser!.email!
                                        .split('@')[0],
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    entryTime: Timestamp.fromDate(
                                        widget.selectedDate!),
                                    photoUrls: '')
                                .toMap())
                            .then((value) {
                          setState(() {
                            currId = value.id;
                          });
                          return null;
                        });
                      }
                      if (_fileBytes != null) {
                        firebase_storage.SettableMetadata? metadata =
                            firebase_storage.SettableMetadata(
                                contentType: 'image/jpeg',
                                customMetadata: {'picked-file-path': path});

                        Future.delayed(const Duration(milliseconds: 1100))
                            .then((value) {
                          fs
                              .ref()
                              .child(
                                  'images/$path${FirebaseAuth.instance.currentUser!.uid}')
                              .putData(_fileBytes!, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              diaryCollectionReference
                                  .doc(currId)
                                  .update({'photo_list': value.toString()});
                            });
                          });
                          return null;
                        });
                      }

                      setState(() {
                        _buttonText = 'Saving...';
                      });
                      Future.delayed(
                        const Duration(milliseconds: 2500),
                      ).then((value) => Navigator.of(context).pop());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        IconButton(
                          splashRadius: 26,
                          icon: const Icon(Icons.image_rounded),
                          onPressed: () async {
                            await getMultipleImageInfos();
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatDate(widget.selectedDate!)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            child: Column(children: [
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height * 0.8) /
                                        2,
                                child: _imageWidget,
                              ),
                              TextFormField(
                                controller: widget._titleTextController,
                                decoration:
                                    const InputDecoration(hintText: 'Title...'),
                              ),
                              TextFormField(
                                maxLines: null, // make true multiline
                                controller: widget._descriptionTextController,
                                decoration: const InputDecoration(
                                    hintText: 'Write your thoughts here...'),
                              )
                            ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    //String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     new html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData?.data;
      _imageWidget = Image.memory(_fileBytes!);
    });
  }
}
