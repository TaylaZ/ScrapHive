import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:scraphive/widgets/material_card.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  double? _percentageValue;
  final TextEditingController _descriptionController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('materials')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<void> _refreshData() async {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('materials')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
    });
  }

  void materialImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadMaterials(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          _percentageValue);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Added');
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
          title: const Text('Create a Material'),
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

  Future<void> _updateMaterialDescription(
      String materialId, String newDescription) async {
    try {
      await FirebaseFirestore.instance
          .collection('materials')
          .doc(materialId)
          .update({'description': newDescription});
      showSnackBar(context, 'Description updated successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to update description: $e');
    }
  }

  void _updatepercentageInDatabase(String materialId, double newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('materials')
          .doc(materialId)
          .update({'percentage': newValue});
      // Optionally, you can update the UI here if needed.
    } catch (e) {
      showSnackBar(context, 'Failed to update percentage: $e');
    }
  }

  void _editMaterialDescription(
      String materialId, String currentDescription) async {
    // Show a dialog or navigate to an edit screen where the user can update the description.
    final newDescription = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller =
            TextEditingController(text: currentDescription);

        return AlertDialog(
          title: Text('Edit Description'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter the new description',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel editing
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the new description to Firestore.
                final newDescription = controller.text;
                _updateMaterialDescription(materialId, newDescription);
                Navigator.of(context).pop(newDescription);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newDescription != null) {
      // Update the UI with the new description if needed.
    }
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
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ScrapHive_Logo.svg',
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    EvaIcons.plus,
                    color: amberColor,
                  ),
                  onPressed: () => _selectImage(context),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _refreshData,
              backgroundColor: amberColor,
              color: yellowColor,
              displacement: 0,
              child: StreamBuilder(
                stream: _stream,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ScrapHiveLoader();
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => MaterialCard(
                        snap: snapshot.data!.docs[index].data(),
                        percentage:
                            snapshot.data!.docs[index]['percentage'] ?? 0.0,
                        onEdit: () => _editMaterialDescription(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]['description'],
                        ),
                        onpercentageChanged: (newValue) {
                          _updatepercentageInDatabase(
                            snapshot.data!.docs[index].id,
                            newValue,
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Tap the top right "plus" button to add a new material',
                        style: TextStyle(color: greyColor),
                      ),
                    );
                  }
                },
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
                  onPressed: () => materialImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    'Add Material',
                    style: TextStyle(
                      color: amberColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? ScrapHiveLoader()
                      : Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                          ),
                        ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Description of Material...",
                              border: InputBorder.none),
                          maxLength: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _percentageValue = double.tryParse(value);
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "How many percent is left?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
