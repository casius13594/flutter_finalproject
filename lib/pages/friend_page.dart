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

  final CollectionReference _friendlist = FirebaseFirestore.instance.collection('friend');
  final CollectionReference _userlist = FirebaseFirestore.instance.collection('user');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> listfriend_state =[];

  // Future<void> fetchdata() async{
  //   try{
  //     // get user except current user
  //     Stream<QuerySnapshot> user_except = await _userlist.where('email',
  //     isNotEqualTo: email_current).snapshots() ;
  //
  //     //get all data from friend table
  //     Stream<QuerySnapshot> friend =
  //     await _friendlist.where('friend1', isEqualTo: email_current).snapshots();
  //
  //     //get all people in friend table whose state is 1
  //     Stream<QuerySnapshot> friendState1 =
  //     await _friendlist
  //         .where('friend1', isEqualTo: email_current)
  //         .where('state', isEqualTo: 1)
  //         .snapshots();
  //
  //     //get all people in friend table whose state is 2
  //     Stream<QuerySnapshot> friendState2 =
  //     await _friendlist
  //         .where('friend1', isEqualTo: email_current)
  //         .where('state', isEqualTo: 2)
  //         .snapshots();
  //
  //     final List<Map<String, dynamic>> emailUsers =
  //     user_except.docs.map((doc) => doc.data()).toList();
  //
  //     final List<Map<String, dynamic>> emailUsersState1 =
  //     emailUsers.toList(); // Copy emailUsers
  //     final List<Map<String, dynamic>> emailUsersState2 =
  //     emailUsers.toList(); // Copy emailUsers
  //
  //     final List<Map<String, dynamic>> emailfriend =
  //     friend.docs.map((doc) => doc.data()).toList();
  //     final List<Map<String, dynamic>> friendsState1 =
  //     friendState1.docs.map((doc) => doc.data()).toList();
  //     final List<Map<String, dynamic>> friendsState2 =
  //     friendState2.docs.map((doc) => doc.data()).toList();
  //
  //     // get user who is not contained in 'friend2' field of friend table
  //     emailUsers.removeWhere((user_item) =>
  //         emailfriend.any((friend_item) => friend_item['friend2'] == user_item['email']));
  //
  //     //
  //     emailUsersState1.removeWhere((user_item) =>
  //         !friendsState1.any((friend_item) => friend_item['friend2'] == user_item['email']));
  //
  //     emailUsersState2.removeWhere((user_item) =>
  //     !friendsState2.any((friend_item) => friend_item['friend2'] == user_item['email']));
  //
  //     //set state for 3 list
  //     for(var item in emailUsers)
  //       {
  //         item['state'] =0;
  //       }
  //
  //     for(var item in emailUsersState1)
  //     {
  //       item['state'] =1;
  //     }
  //
  //     for(var item in emailUsersState2)
  //     {
  //       item['state'] =2;
  //     }
  //
  //     listfriend_state.addAll(emailUsersState1);
  //     listfriend_state.addAll(emailUsersState2);
  //     listfriend_state.addAll(emailUsers);
  //
  //     setState(() {
  //       listfriend_state.addAll(emailUsersState1);
  //       listfriend_state.addAll(emailUsersState2);
  //       listfriend_state.addAll(emailUsers);
  //     });
  //   }
  //   catch(e){
  //     print('Error fetiching data: $e');
  //   }
  // }
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

      List<Map<String, dynamic>> emailUsers =
      userExcept.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      List<Map<String, dynamic>> emailUsersState1 =
      List<Map<String, dynamic>>.from(emailUsers);
      List<Map<String, dynamic>> emailUsersState2 =
      List<Map<String, dynamic>>.from(emailUsers);

      List<Map<String, dynamic>> emailFriend =
      friend.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> friendsState1 =
      friendState1.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> friendsState2 =
      friendState2.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      emailUsers.removeWhere((user_item) =>
          emailFriend.any((friend_item) => friend_item['friend2'] == user_item['email']));

      emailUsersState1.removeWhere((user_item) =>
      !friendsState1.any((friend_item) => friend_item['friend2'] == user_item['email']));

      emailUsersState2.removeWhere((user_item) =>
      !friendsState2.any((friend_item) => friend_item['friend2'] == user_item['email']));

      for (var item in emailUsers) {
        item['state'] = 0;
      }

      for (var item in emailUsersState1) {
        item['state'] = 1;
      }

      for (var item in emailUsersState2) {
        item['state'] = 2;
      }

      setState(() {
        print('Set state');
        listfriend_state.clear();
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
    fetchData();
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Implement search functionality here
                    // You can filter the dataList based on the search input.
                    // For simplicity, we'll just display all data here.
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listfriend_state.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = listfriend_state[index];
                return ListTile(
                  title: Text(item['name']),
                  leading: Icon(
                    Icons.person,
                  ),
                  trailing: ElevatedButton(
                      onPressed: (){},
                      child: liststate(item['state']),
                    ),
                  // Replace 'name' with the field you want to display// Replace 'description' as needed
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


}