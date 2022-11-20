import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/diary.dart';
import '../model/user.dart';
import '../services/service.dart';
import '../widgets/create_profile.dart';
import '../widgets/diary_list_view.dart';
import '../widgets/write_diary_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime selectedDate = DateTime.now();
  late Future<List<Diary>> userDiaryFilteredEntriesList;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleTextController = TextEditingController();
    TextEditingController descriptionTextController = TextEditingController();
    var listOfDiaries = Provider.of<List<Diary>>(context);
    var user = Provider.of<User?>(context);
    late dynamic latestFilteredDiariesStream;
    late dynamic earliestFilteredDiariesStream;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(
          children: [
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            const Text(
              'Book',
              style: TextStyle(fontSize: 39, color: Colors.green),
            )
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  hint: (_dropDownText == null)
                      ? const Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      listOfDiaries.clear();
                      latestFilteredDiariesStream =
                          DiaryService().getLatestDiaries(user!.uid);
                      latestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            listOfDiaries.add(item);
                          });
                        }
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      listOfDiaries.clear();
                      earliestFilteredDiariesStream =
                          DiaryService().getEarliestDiaries(user!.uid);

                      earliestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            listOfDiaries.add(item);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    return (muser.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();
                  print(usersListStream.length);

                  MUser curUser = usersListStream[0];

                  return CreateProfile(curUser: curUser);
                },
              ),
            ],
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                // color: Colors.green,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged: (dateRangePickerSelection) {
                          setState(() {
                            selectedDate = dateRangePickerSelection.value;
                            listOfDiaries.clear();
                            userDiaryFilteredEntriesList = DiaryService()
                                .getSameDateDiaries(
                                    Timestamp.fromDate(selectedDate).toDate(),
                                    FirebaseAuth.instance.currentUser!.uid);

                            userDiaryFilteredEntriesList.then((value) {
                              for (var item in value) {
                                setState(() {
                                  listOfDiaries.add(item);
                                });
                              }
                            });
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Card(
                        elevation: 4,
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.greenAccent,
                          ),
                          label: const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WriteDiaryDialog(
                                    selectedDate: selectedDate,
                                    titleTextController: titleTextController,
                                    descriptionTextController:
                                        descriptionTextController);
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 10,
              child: DiaryListView(
                  listOfDiaries: listOfDiaries, selectedDate: selectedDate))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(
                    selectedDate: selectedDate,
                    titleTextController: titleTextController,
                    descriptionTextController: descriptionTextController);
              },
            );
          },
          tooltip: 'Add',
          child: const Icon(
            Icons.add,
          )),
    );
  }
}
