import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/diary.dart';
import '../util/utils.dart';
import 'inner_list_card.dart';
import 'write_diary_dialog.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required List<Diary> listOfDiaries,
    required this.selectedDate,
  })  : _listOfDiaries = listOfDiaries,
        super(key: key);
  final DateTime selectedDate;
  final List<Diary> _listOfDiaries;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleTextController = TextEditingController();
    TextEditingController descriptionTextController = TextEditingController();
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    final user = Provider.of<User?>(context);

    var diaryList = _listOfDiaries;
    var filteredDiaryList = diaryList.where((element) {
      return (element.userId == user!.uid);
    }).toList();
    return Column(
      children: [
        Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: (filteredDiaryList.isNotEmpty)
              ? ListView.builder(
                  itemCount: filteredDiaryList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredDiaryList[index];

                    return DelayedDisplay(
                      delay: const Duration(milliseconds: 1),
                      fadeIn: true,
                      child: Card(
                        elevation: 4.0,
                        child: InnerListCard(
                            selectedDate: selectedDate,
                            diary: diary,
                            bookCollectionReference: bookCollectionReference),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return DelayedDisplay(
                      fadeIn: true,
                      delay: const Duration(milliseconds: 2),
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Safeguard your memory on ${formatDate(selectedDate)}',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    TextButton.icon(
                                      icon:
                                          const Icon(Icons.lock_outline_sharp),
                                      label:
                                          const Text('Click to Add an Entry'),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return WriteDiaryDialog(
                                                selectedDate: selectedDate,
                                                titleTextController:
                                                    titleTextController,
                                                descriptionTextController:
                                                    descriptionTextController);
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ))
      ],
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }
              var filteredList = snapshot.data!.docs.map((diary) {
                return Diary.fromDocument(diary);
              }).where((item) {
                return (item.userId == FirebaseAuth.instance.currentUser!.uid);
              }).toList();

              return Column(
                children: [
                  Expanded(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        Diary diary = filteredList[index];
                        return Card(
                          elevation: 4.0,
                          child: InnerListCard(
                              selectedDate: this.selectedDate,
                              diary: diary,
                              bookCollectionReference: bookCollectionReference),
                        );
                      },
                    ),
                  ))
                ],
              );
            },
          )
*/
