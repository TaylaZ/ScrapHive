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
import 'package:scraphive/widgets/hexagon_button.dart';
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
        ? Transform.translate(
            offset: Offset(0, 50),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(-50, 0),
                      child: GestureDetector(
                        onTap: () => _selectImage(context),
                        child: HexagonIcon(
                          icon: EvaIcons.upload,
                          iconColor: primaryColor,
                          fillColor: amberColor,
                          iconSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-50, 0),
                    child: Text(
                      'Add Post',
                      style: TextStyle(
                        color: amberColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(50, -50),
                      child: GestureDetector(
                        onTap: () async {
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
                        child: HexagonIcon(
                          icon: EvaIcons.image,
                          iconColor: primaryColor,
                          fillColor: greenColor,
                          iconSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(50, -50),
                    child: Text(
                      'Edit Image',
                      style: TextStyle(
                        color: greenColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(-50, -100),
                      child: GestureDetector(
                        onTap: () => _selectImage(context),
                        child: HexagonIcon(
                          icon: EvaIcons.options2Outline,
                          iconColor: primaryColor,
                          fillColor: peachColor,
                          iconSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-50, -100),
                    child: Text(
                      'Adjustments',
                      style: TextStyle(
                        color: peachColor,
                      ),
                    ),
                  ),
                ],
              ),
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
