import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/diary.dart';
import '../util/utils.dart';
import 'delete_entry_dialog.dart';
import 'update_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.diary,
    required this.selectedDate,
    required this.bookCollectionReference,
  }) : super(key: key);

  final Diary diary;
  final DateTime? selectedDate;
  final CollectionReference<Object?> bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleTextController =
        TextEditingController(text: diary.title);
    final TextEditingController descriptionTextController =
        TextEditingController(text: diary.entry);
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateFromTimestamp(diary.entryTime),
                  style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteEntryDialog(
                              bookCollectionReference: bookCollectionReference,
                              diary: diary);
                        },
                      );
                    },
                    label: const Text(''))
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('•${formatDateFromTimestampHour(diary.entryTime)}',
                      style: const TextStyle(color: Colors.green)),
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                      label: const Text('')),
                ],
              ),
              Image.network((diary.photoUrls == null)
                  ? 'https://picsum.photos/400/200'
                  : diary.photoUrls.toString()),
              Row(
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(diary.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              diary.entry,
                            ),
                          ),
                        ]),
                  ),
                ],
              )
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            Text(
                              formatDateFromTimestamp(diary.entryTime),
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateEntryDialog(
                                        diary: diary,
                                        titleTextController:
                                            titleTextController,
                                        descriptionTextController:
                                            descriptionTextController,
                                        widget: this,
                                        linkReference: bookCollectionReference,
                                      );
                                    },
                                  );
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete_forever_rounded),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteEntryDialog(
                                          bookCollectionReference:
                                              bookCollectionReference,
                                          diary: diary);
                                    },
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                  content: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '• ${formatDateFromTimestampHour(diary.entryTime)}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: Image.network((diary.photoUrls == null)
                                ? 'https://picsum.photos/400/200'
                                : diary.photoUrls.toString())),
                        Row(
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${diary.title}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  //using
                                  child: Text(
                                    '${diary.entry}',
                                    // overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
