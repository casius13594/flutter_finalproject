import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/chat_page.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late double height, width;
  String name = '';
  String? email_current;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> listfriend_state_withName = [];

  Future<void> fetchData() async {
    try {
      if (user != null) {
        email_current = user!.email;
        QuerySnapshot<Map<String, dynamic>> userExcept = await _firestore
            .collection('users')
            .where('email', isNotEqualTo: email_current)
            .get();

        QuerySnapshot<Map<String, dynamic>> friend = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .get();

        // get friend state 1: send invitation
        QuerySnapshot<Map<String, dynamic>> friendState1 = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .where('state', isEqualTo: 1)
            .get();

        // get friend state 2: friend
        QuerySnapshot<Map<String, dynamic>> friendState2 = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .where('state', isEqualTo: 2)
            .get();
        // get friend state 3: recieve invitation
        QuerySnapshot<Map<String, dynamic>> friendState3 = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .where('state', isEqualTo: 3)
            .get();

        List<Map<String, dynamic>> emailUsersState1 = userExcept.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        List<Map<String, dynamic>> emailUsersState2 =
            List<Map<String, dynamic>>.from(emailUsersState1);
        List<Map<String, dynamic>> emailUsersState3 =
            List<Map<String, dynamic>>.from(emailUsersState1);

        // convert into list from friend table
        List<Map<String, dynamic>> emailFriend = friend.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        List<Map<String, dynamic>> friendsState1 = friendState1.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        List<Map<String, dynamic>> friendsState2 = friendState2.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        List<Map<String, dynamic>> friendsState3 = friendState3.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // get users who states 1 in friend table
        emailUsersState1.removeWhere((user_item) => !friendsState1.any(
            (friend_item) => friend_item['friend2'] == user_item['email']));

        // get users who states 2 in friend table
        emailUsersState2.removeWhere((user_item) => !friendsState2.any(
            (friend_item) => friend_item['friend2'] == user_item['email']));

        // get users who states 3 in friend table
        emailUsersState3.removeWhere((user_item) => !friendsState3.any(
            (friend_item) => friend_item['friend2'] == user_item['email']));

        for (var item in emailUsersState1) {
          item['state'] = 1;
        }

        for (var item in emailUsersState2) {
          item['state'] = 2;
        }

        for (var item in emailUsersState3) {
          item['state'] = 3;
        }

        setState(() {
          print('Set state');
          listfriend_state_withName.clear();
          listfriend_state_withName.addAll(emailUsersState3);
          listfriend_state_withName.addAll(emailUsersState1);
          listfriend_state_withName.addAll(emailUsersState2);
          print('load okki');
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    _firestore.collection('friend').snapshots().listen((event) {
      fetchData(); // Update data when changes occur
    });

    _firestore.collection('users').snapshots().listen((event) {
      fetchData(); // Update data when changes occur
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        title: Text(
          'Friend',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Theme.of(context).colorScheme.surfaceVariant),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listfriend_state_withName.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = listfriend_state_withName[index];
                return Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: InkWell(
                    onTap: () {
                      ChatUserProfile user_chat =
                          ChatUserProfile.fromJson(item);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatPage(user: user_chat)));
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(item['name']),
                          SizedBox(width: 5),
                          is_online(item['is_active']),
                        ],
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(height * .03),
                        child: CachedNetworkImage(
                          width: height * .055,
                          height: height * .055,
                          imageUrl: item['image'],
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                      trailing: (item['state'] != 3)
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: liststate(item['state']),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    deleteFriendState(email_current!,
                                        item['email'], 0, index);
                                    deleteFriendState(
                                        item['email'], email_current!, 0, -1);
                                  },
                                  child: Text(
                                    'Reject',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    updateFriendState(email_current!,
                                        item['email'], 2, index);
                                    updateFriendState(
                                        item['email'], email_current!, 2, -1);
                                  },
                                  child: Text('Accept'),
                                ),
                              ],
                            ),
                      // Replace 'name' with the field you want to display// Replace 'description' as needed
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  liststate(int state) {
    switch (state) {
      case 0:
        return Text('Connect');
        break;
      case 1:
        return Text('Pending');
        break;
      case 2:
        return Text('Friend');
        break;
      default:
        return Text('Connect');
        break;
    }
  }

  is_online(bool check) {
    return (check)
        ? Container(
            width: 8.0, // Adjust the width and height as needed
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Create a circular shape
              color: Colors
                  .blue, //Theme.of(context).colorScheme.primary,   // Set the color to green
            ),
          )
        : Container(
            width: 8.0, // Adjust the width and height as needed
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Create a circular shape
              color: Colors.grey[
                  900], //Theme.of(context).colorScheme.onSecondary,   // Set the color to green
            ),
          );
  }

  Future<void> updateFriendState(String email_friend1, String email_friend2,
      int newState, int index) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('friend')
          .where('friend1', isEqualTo: email_friend1)
          .where('friend2', isEqualTo: email_friend2)
          .get();

      // Loop through the documents and update them
      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> doc) async {
        // Extract the document ID
        String docId = doc.id;

        // Update the document
        await _firestore.collection('friend').doc(docId).update({
          'state':
              newState, // Replace with the field and new value you want to update
        });

        print('Document $docId updated successfully.');
      });

      // Update the local state to reflect the change (assuming you have a way to track the local state)
      setState(() {
        if (index != -1) {
          listfriend_state_withName[index]['state'] = newState;
        }
      });
    } catch (e) {
      print('Error updating friend state: $e');
    }
  }

  Future<void> deleteFriendState(
      String email_friend1, String email_friend2, int state, int index) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshotadd = await _firestore
          .collection('friend')
          .where('friend1', isEqualTo: email_friend1)
          .where('friend2', isEqualTo: email_friend2)
          .get();

      querySnapshotadd.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> doc) async {
        // Extract the document ID
        String docId = doc.id;

        // Update the document
        await _firestore.collection('friend').doc(docId).delete();

        print('Document $docId updated successfully.');
      });

      setState(() {
        if (index != -1) {
          listfriend_state_withName.removeAt(index);
        }
      });
    } catch (e) {
      print('Error delete friend state: $e');
    }
  }
}
