import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/screens/ProfileScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController serachController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    serachController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            title: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: serachController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey)),
                  onFieldSubmitted: (String _) {
                    print(_);
                    setState(() {
                      isShowUsers = true;
                    });
                  }),
            ),
          ),
          body: SafeArea(
            child: isShowUsers
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isGreaterThanOrEqualTo: serachController.text)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if(snapshot.hasError)
                        {
                         showSnackBar("Something went wrong", context);
                        }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            uid: snapshot.data!.docs[index]['uid'],
                                          ))),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index]['photoURL'],
                                  ),
                                  radius: 16,
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['username'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          });
                    },
                  )
                : FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished')
                        .get(),
                    builder: (context,
                        // AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return MasonryGridView.count(
                        crossAxisCount: 3,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postURL'],
                          fit: BoxFit.cover,
                        ),
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 3.0,
                      );
                    }),
          )),
    );
  }
}
