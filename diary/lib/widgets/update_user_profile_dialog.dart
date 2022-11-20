import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/service.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.curUser,
    required TextEditingController avatarUrlTextController,
    required TextEditingController displayNameTextController,
  })  : _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        super(key: key);

  final MUser curUser;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _displayNameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Editing ${curUser.displayName}',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _avatarUrlTextController,
                    ),
                    TextFormField(
                      controller: _displayNameTextController,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                side:
                                    BorderSide(color: Colors.green, width: 1))),
                        child: const Text('Update'),
                        onPressed: () {
                          DiaryService().update(
                              curUser,
                              _displayNameTextController.text,
                              _avatarUrlTextController.text,
                              context);
                          Future.delayed(
                            const Duration(milliseconds: 200),
                          ).then((value) {
                            return Navigator.of(context).pop();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
