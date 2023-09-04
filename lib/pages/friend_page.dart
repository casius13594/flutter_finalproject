import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Friendpage extends StatefulWidget{
  final String current_email_pg;
  const Friendpage({super.key,required this.current_email_pg});

  @override
  State<StatefulWidget> createState()  => _FriendPageState(this.current_email_pg);

}

class _FriendPageState extends State<Friendpage>{
  late double height, width;
  String name ='';
  String email_current='';

  _FriendPageState(String email)
  {
    this.email_current=email;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> listfriend_state =[];
  List<Map<String, dynamic>> listfriend_state_withName =[];

  Future<void> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userExcept =
      await _firestore.collection('users').where('email', isNotEqualTo: email_current).get();

      QuerySnapshot<Map<String, dynamic>> friend =
      await _firestore.collection('friend').where('friend1', isEqualTo: email_current).get();

      QuerySnapshot<Map<String, dynamic>> friendState1 = await _firestore
          .collection('friend')
          .where('friend1', isEqualTo: email_current)
          .where('state', isEqualTo: 1)
          .get();

      QuerySnapshot<Map<String, dynamic>> friendState2 = await _firestore
          .collection('friend')
          .where('friend1', isEqualTo: email_current)
          .where('state', isEqualTo: 2)
          .get();

      QuerySnapshot<Map<String, dynamic>> friendState3 = await _firestore
          .collection('friend')
          .where('friend1', isEqualTo: email_current)
          .where('state', isEqualTo: 3)
          .get();

      List<Map<String, dynamic>> emailUsers =
      userExcept.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      List<Map<String, dynamic>> emailUsersState1 =
      List<Map<String, dynamic>>.from(emailUsers);
      List<Map<String, dynamic>> emailUsersState2 =
      List<Map<String, dynamic>>.from(emailUsers);
      List<Map<String, dynamic>> emailUsersState3 =
      List<Map<String, dynamic>>.from(emailUsers);

      List<Map<String, dynamic>> emailFriend =
      friend.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> friendsState1 =
      friendState1.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> friendsState2 =
      friendState2.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> friendsState3 =
      friendState3.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      emailUsers.removeWhere((user_item) =>
          emailFriend.any((friend_item) => friend_item['friend2'] == user_item['email']));

      emailUsersState1.removeWhere((user_item) =>
      !friendsState1.any((friend_item) => friend_item['friend2'] == user_item['email']));

      emailUsersState2.removeWhere((user_item) =>
      !friendsState2.any((friend_item) => friend_item['friend2'] == user_item['email']));

      emailUsersState3.removeWhere((user_item) =>
      !friendsState3.any((friend_item) => friend_item['friend2'] == user_item['email']));

      for (var item in emailUsers) {
        item['state'] = 0;
      }

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
        listfriend_state.clear();
        listfriend_state.addAll(emailUsersState3);
        listfriend_state.addAll(emailUsersState1);
        listfriend_state.addAll(emailUsersState2);
        listfriend_state.addAll(emailUsers);
        print('load okki');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    listfriend_state_withName = listfriend_state;
    fetchData();
  }

  void fitter(String keyValue)
  {
    List<Map<String,dynamic>> results =[];
    if(keyValue.isEmpty)
      {
        results = listfriend_state;
      }
    else
      {
        results=listfriend_state
            .where((element) => element['name'].toString().toLowerCase().contains(keyValue.toLowerCase()))
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
            'Friend',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Theme.of(context).colorScheme.surfaceVariant
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
            ),
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
        ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: Icon( Icons.search,
                ),
              ),
              onChanged: (val){
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
                  child: ListTile(
                    title: Text(item['name']),
                    leading: Icon(
                      Icons.person,
                    ),
                    trailing: (item['state']!=3)?
                        Row(mainAxisSize: MainAxisSize.min,
                          children: <Widget> [
                            is_online(item['is_active']),
                            SizedBox(width: 5),
                            ElevatedButton(
                                onPressed: (){
                                  if(item['state'] == 0)
                                  {
                                    addFriendState(email_current, item['email'], 1, index);
                                    addFriendState(item['email'], email_current, 3, -1);
                                  }
                                },
                                child: liststate(item['state']),
                              ),
                          ],
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            is_online(item['is_active']),
                            ElevatedButton(
                              onPressed: (){
                                deleteFriendState(email_current, item['email'], 0, index);
                                deleteFriendState(item['email'], email_current, 0, -1);
                              },
                              child: Text('Reject',),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                updateFriendState(email_current, item['email'], 2, index);
                                updateFriendState(item['email'], email_current, 2, -1);
                              },
                              child: Text('Accept'),
                            ),
                          ],
                        ),
                    // Replace 'name' with the field you want to display// Replace 'description' as needed
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
    switch(state)
    {
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

  is_online(bool check)
  {
    return (check)?
      Container(
      width: 20.0, // Adjust the width and height as needed
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Create a circular shape
        color: Colors.green[900],//Theme.of(context).colorScheme.primary,   // Set the color to green
      ),
      ) : Container(
      width: 20.0, // Adjust the width and height as needed
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Create a circular shape
        color: Colors.grey[900],//Theme.of(context).colorScheme.onSecondary,   // Set the color to green
        ),
      );
  }

  Future<void> updateFriendState(String email_friend1, String email_friend2, int newState, int index) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('friend')
          .where('friend1',isEqualTo: email_friend1)
          .where('friend2', isEqualTo: email_friend2)
          .get();

      // Loop through the documents and update them
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) async {
        // Extract the document ID
        String docId = doc.id;

        // Update the document
        await _firestore.collection('friend').doc(docId).update({
          'state': newState, // Replace with the field and new value you want to update
        });

        print('Document $docId updated successfully.');
      });

      // Update the local state to reflect the change (assuming you have a way to track the local state)
      setState(() {
        if(index!=-1)
        {
        listfriend_state[index]['state'] = newState;
        }
      });
    } catch (e) {
      print('Error updating friend state: $e');
    }
  }


  Future<void> addFriendState(String email_friend1, String email_friend2, int state, int index) async {
    try {

      // Add the new friend to Firestore
      DocumentReference newFriendDoc = await _firestore.collection('friend').add({
        'friend1': email_friend1,
        'friend2': email_friend2,
        'state': state, // You can set the initial state here
      });

      // Update the local state to add the new friend
      setState(() {
        if(index !=-1) {
          listfriend_state[index]['state'] = state;
        }
      });

      print('New friend added with ID ${newFriendDoc.id}');
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  Future<void> deleteFriendState(String email_friend1, String email_friend2, int state, int index) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshotadd = await _firestore
          .collection('friend')
          .where('friend1',isEqualTo: email_friend1)
          .where('friend2', isEqualTo: email_friend2)
          .get();

      querySnapshotadd.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) async {
        // Extract the document ID
        String docId = doc.id;

        // Update the document
        await _firestore.collection('friend').doc(docId).delete();

        print('Document $docId updated successfully.');
      });

      setState(() {
        if(index !=-1) {
          listfriend_state[index]['state'] = 0;
        }
      });
    } catch (e) {
      print('Error delete friend state: $e');
    }
  }


}