import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:instagram_clone_flutter/assets/colors.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:provider/provider.dart';
import '../models/users.dart';
import '../resources/firestore_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: const Text("Create a Post"),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Take a Photo"),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Choose from Gallery"),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
  void clearImage()
  {
    setState(() {
      _file=null;
    });
  }
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading=true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == 'success') {
        setState(() {
          _isLoading=false;
        });
        showSnackBar('Posted', context);
        clearImage();
      } else {
        setState(() {
          _isLoading=false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload,color: Colors.blue,),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor:Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.black,),
                onPressed:clearImage,
              ),
              title: Text("Post to",style: TextStyle(color: Colors.black),),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoURL),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading?LinearProgressIndicator():Padding(padding: EdgeInsets.only(top:2)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Caption..",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),),
                        maxLines: 8,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(_file!),
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
