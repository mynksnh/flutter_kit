import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../model/diary.dart';
import '../util/utils.dart';
import 'delete_entry_dialog.dart';
import 'inner_list_card.dart';

class UpdateEntryDialog extends StatefulWidget {
  const UpdateEntryDialog({
    Key? key,
    required this.diary,
    required CollectionReference linkReference,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
    required this.widget,
    this.cloudFile,
    this.fileBytes,
    this.imageWidget,
  })  : _titleTextController = titleTextController,
        _linkReference = linkReference,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final Diary diary;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final CollectionReference _linkReference;
  final InnerListCard widget;
  final html.File? cloudFile;
  final Uint8List? fileBytes;
  final Image? imageWidget;

  @override
  UpdateEntryDialogState createState() => UpdateEntryDialogState();
}

class UpdateEntryDialogState extends State<UpdateEntryDialog> {
  Uint8List? _fileBytes;
  Image? _imageWidget;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Discard')),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        disabledForegroundColor: Colors.blueGrey,
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.green, width: 1))),
                    onPressed: () {
                      var user = FirebaseAuth.instance.currentUser;
                      final fieldNotEmpty =
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;
                      final diaryTitleChanged = widget.diary.title !=
                          widget._titleTextController.text;
                      final diaryEntryChanged = widget.diary.entry !=
                          widget._descriptionTextController.text;

                      final diaryUpdate = diaryTitleChanged ||
                          diaryEntryChanged ||
                          _fileBytes != null;

                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;

                      final dateTime = DateTime.now();
                      final path = '$dateTime';

                      if (fieldNotEmpty && diaryUpdate) {
                        widget._linkReference.doc(widget.diary.id).update(Diary(
                                userId: user!.uid,
                                author: user.email!.split('@')[0],
                                title: widget._titleTextController.text,
                                entry: widget._descriptionTextController.text,
                                photoUrls: (widget.diary.photoUrls != null)
                                    ? widget.diary.photoUrls.toString()
                                    : '',
                                entryTime: Timestamp.fromDate(
                                    //widget.widget.selectedDate!,
                                    DateTime.now()))
                            .toMap());

                        // only update image if it's not null
                        if (_fileBytes != null) {
                          firebase_storage.SettableMetadata? metadata =
                              firebase_storage.SettableMetadata(
                                  contentType: 'image/jpeg',
                                  customMetadata: {'picked-file-path': path});

                          fs
                              .ref()
                              .child('images/$path${user.uid}')
                              .putData(_fileBytes!, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              widget._linkReference
                                  .doc(widget.diary.id!)
                                  .update({'photo_list': value.toString()});
                              print(value.toString());
                            });
                          });
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Done'),
                    ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () async {
                                await getMultipleImageInfos();
                              },
                              splashRadius: 26,
                              icon: const Icon(Icons.image_rounded)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteEntryDialog(
                                        bookCollectionReference:
                                            widget._linkReference,
                                        diary: widget.diary);
                                  },
                                );
                              },
                              splashRadius: 26,
                              color: Colors.red,
                              icon: const Icon(Icons.delete_outline_rounded)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatDateFromTimestamp(widget.diary.entryTime)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (_imageWidget != null)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _imageWidget,
                                    )
                                  : Image.network(
                                      (widget.diary.photoUrls == null)
                                          ? 'https://picsum.photos/400/200'
                                          : widget.diary.photoUrls.toString()),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                              child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {},
                                controller: widget._titleTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Title...',
                                ),
                              ),
                              TextFormField(
                                maxLines:
                                    null, // make this null so that we have true multiline
                                validator: (value) {},
                                keyboardType: TextInputType.multiline,
                                controller: widget._descriptionTextController,
                                decoration: const InputDecoration(
                                    hintText: 'Writy your thoughts here...'),
                              )
                            ],
                          )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    // String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     new html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData?.data;
      _imageWidget = Image.memory(_fileBytes!);
    });
  }
}
