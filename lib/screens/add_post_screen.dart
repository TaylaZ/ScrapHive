import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scraphive/providers/user_provider.dart';
import 'package:scraphive/resources/firestore_methods.dart';
import 'package:scraphive/screens/edit_image_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:scraphive/utils/utils.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Posted');
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Container(
            color: yellowColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: amberColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          EvaIcons.plusCircleOutline,
                          color: primaryColor,
                        ),
                        onPressed: () => _selectImage(context),
                        iconSize: 40,
                      ),
                      Text(
                        'Add Post',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          EvaIcons.image,
                          color: primaryColor,
                        ),
                        iconSize: 40,
                        onPressed: () async {
                          XFile? file = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (file != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditImageScreen(
                                  selectedImage: file.path,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        'Edit Image',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(EvaIcons.arrowBack),
                color: amberColor,
                onPressed: clearImage,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/ScrapHive_Logo.svg',
                    height: 28,
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: amberColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? ScrapHiveLoader()
                    : Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
