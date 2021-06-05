import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:dmman/widgets/tile.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/models/message.dart';
import 'package:dmman/widgets/appBar.dart';
import 'package:dmman/api/chat_methods.dart';
import 'package:dmman/utils/call_utils.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/utils/permissions.dart';
import 'package:dmman/constants/strings.dart';
import 'package:dmman/api/storage_methods.dart';
import 'package:dmman/contents/view_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:dmman/widgets/cached_image.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmman/provider/image_upload_provider.dart';

class ChatScreen extends StatefulWidget {
  final User rec;

  ChatScreen({this.rec});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final StorageMethods _storageMethods = StorageMethods();
  bool isWriting = false;
  bool showEmojiPicker = false;
  User sen;
  String _currentUserId;
  ScrollController _listScrollController = ScrollController();
  FocusNode textFieldNode = FocusNode();
  ImageUploadProvider _imageUploadProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sen = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard() => textFieldNode.requestFocus();

  hideKeyboard() => textFieldNode.unfocus();

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
      backgroundColor: UniversalVariables.black,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.pc,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      recommendKeywords: EMOJI_RECOMMEND,
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.rec.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: circularProgress());
        }

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _msg = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _msg.senId == _currentUserId
            ? Alignment.topRight
            : Alignment.topLeft,
        child: _msg.senId == _currentUserId ? senLayout(_msg) : recLayout(_msg),
      ),
    );
  }

  Widget senLayout(Message msg) {
    Radius msgRadius = Radius.circular(20);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senColor,
        borderRadius: BorderRadius.only(
          topLeft: msgRadius,
          bottomLeft: msgRadius,
          bottomRight: msgRadius,
        ),
      ),
      child: Padding(padding: EdgeInsets.all(10), child: getMsg(msg)),
    );
  }

  Widget recLayout(Message msg) {
    Radius msgRadius = Radius.circular(20);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.recColor,
        borderRadius: BorderRadius.only(
          topRight: msgRadius,
          bottomLeft: msgRadius,
          bottomRight: msgRadius,
        ),
      ),
      child: Padding(padding: EdgeInsets.all(10), child: getMsg(msg)),
    );
  }

  getMsg(Message msg) {
    return msg.type != MESSAGE_TYPE_IMAGE
        ? Text(
            msg.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        : msg.photoUrl != null
            ? CachedImage(
                msg.photoUrl,
                width: 250,
                height: 250,
                radius: 10,
              )
            : Text(
                "Url not found",
                style: TextStyle(fontFamily: "Lato"),
              );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.black,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content & Tools",
                            style: TextStyle(
                                fontFamily: "Sen",
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share",
                        icon: Icons.image,
                        onTap: () => pickImage(src: ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: UniversalVariables.pc, shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: textEditingController,
                  focusNode: textFieldNode,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: TextStyle(
                      fontFamily: "Sen",
                      color: UniversalVariables.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        hideKeyboard();
                        showEmojiContainer();
                      } else {
                        showKeyboard();
                        hideEmojiContainer();
                      }
                    },
                    icon: Icon(
                      Icons.tag_faces,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(src: ImageSource.camera),
                  child: Icon(Icons.camera)),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: UniversalVariables.pc, shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () => sendMessage()),
                )
              : Container(),
        ],
      ),
    );
  }

  sendMessage() {
    var text = textEditingController.text;

    Message _msg = Message(
      recId: widget.rec.uid,
      senId: sen.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    textEditingController.text = "";

    _chatMethods.addMsgToDB(_msg, sen, widget.rec);
  }

  void pickImage({@required ImageSource src}) async {
    File selectedImage = await Utils.pickImage(src: src);

    _storageMethods.uploadImage(
        img: selectedImage,
        recId: widget.rec.uid,
        senId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.rec.name.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontFamily: "OS",
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
            color: Colors.white,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(from: sen, to: widget.rec, context: context)
                  : {},
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.phone,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.recColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.grey,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: "OS",
            color: UniversalVariables.grey,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: "Sen",
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
