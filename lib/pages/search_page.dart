import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/chat_page.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import '../apis/apis.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late double height, width;
  String name = '';
  String? email_current;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> listfriend_state = [];
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

        QuerySnapshot<Map<String, dynamic>> friendState1 = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .where('state', isEqualTo: 1)
            .get();

        QuerySnapshot<Map<String, dynamic>> friendState3 = await _firestore
            .collection('friend')
            .where('friend1', isEqualTo: email_current)
            .where('state', isEqualTo: 3)
            .get();

        List<Map<String, dynamic>> emailUsers = userExcept.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        List<Map<String, dynamic>> emailFriend = friend.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        emailUsers.removeWhere((user_item) => emailFriend.any(
            (friend_item) => friend_item['friend2'] == user_item['email']));

        for (var item in emailUsers) {
          item['state'] = 0;
        }

        setState(() {
          print('Set state');
          listfriend_state.clear();
          listfriend_state_withName.clear();
          listfriend_state.addAll(emailUsers);
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
    listfriend_state_withName = listfriend_state;
    fetchData();

    _firestore.collection('friend').snapshots().listen((event) {
      fetchData(); // Update data when changes occur
    });

    _firestore.collection('users').snapshots().listen((event) {
      fetchData(); // Update data when changes occur
    });
  }

  void fitter(String keyValue) {
    List<Map<String, dynamic>> results = [];
    if (keyValue.isEmpty) {
      results = listfriend_state;
    } else {
      results = listfriend_state
          .where((element) => element['name']
              .toString()
              .toLowerCase()
              .contains(keyValue.toLowerCase()))
          .toList();
    }

    setState(() {
      listfriend_state_withName = results;
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
          'Search',
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: Icon(
                  Icons.search,
                ),
              ),
              onChanged: (val) {
                fitter(val);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listfriend_state_withName.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = listfriend_state_withName[index];
                return Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: InkWell(
                    onTap: () {
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: () {
                                APIs.addUserIntoChat(item['email']);
                                if (item['state'] == 0) {
                                  addFriendState(
                                      email_current!, item['email'], 1, index);
                                  addFriendState(
                                      item['email'], email_current!, 3, -1);
                                }
                              },
                              child: liststate(item['state']),
                            ),
                          ],
                        )
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

  Future<void> addFriendState(
      String email_friend1, String email_friend2, int state, int index) async {
    try {
      // Add the new friend to Firestore
      DocumentReference newFriendDoc =
          await _firestore.collection('friend').add({
        'friend1': email_friend1,
        'friend2': email_friend2,
        'state': state, // You can set the initial state here
      });

      // Update the local state to add the new friend
      setState(() {
        if (index != -1) {
          listfriend_state[index]['state'] = state;
        }
      });

      print('New friend added with ID ${newFriendDoc.id}');
    } catch (e) {
      print('Error adding friend: $e');
    }
  }
}
