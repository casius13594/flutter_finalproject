import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/models/message.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import 'package:flutter_finalproject/widgets/card_message.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_user.dart';
import '../widgets/card_user.dart';
import '../apis/apis.dart';

class ChatPage extends StatefulWidget {
  final ChatUserProfile user;
  const ChatPage({super.key, required this.user});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Message> _list = [];
  bool isTextFieldExpanded = false;
  final _textController = TextEditingController();
  bool _EmojiMenu = false;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_EmojiMenu) {
              setState(() => _EmojiMenu = !_EmojiMenu);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            body: Column(children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMess(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //check data loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: ms.height * 0.02),
                            itemBuilder: (context, index) {
                              return CardMessage(message: _list[index]);
                            },
                            addAutomaticKeepAlives: true,
                          );
                        } else {
                          return const Center(
                            child:
                                Text('Welcome', style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),
              Form(
                key: _formKey,
                child: _chatInput(),
              ),
              if (_EmojiMenu)
                SizedBox(
                  height: ms.height * .35,
                  child: EmojiPicker(
                    textEditingController:
                        _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.30
                              : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ), // Needs to be const Widget
                      loadingIndicator:
                          const SizedBox.shrink(), // Needs to be const Widget
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align content at the ends
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(ms.height * .03),
              child: CachedNetworkImage(
                width: ms.height * .055,
                height: ms.height * .055,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            // Handle the info button action
          },
          icon: const Icon(
            Icons.info,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() => _EmojiMenu = !_EmojiMenu);
          },
          icon: const Icon(Icons.emoji_emotions, color: Colors.blueAccent),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: TextFormField(
                      key: Key('messageField'),
                      onChanged: (text) {
                        setState(() {
                          isTextFieldExpanded = text.isNotEmpty;
                          if (_EmojiMenu) {
                            setState(() => _EmojiMenu = !_EmojiMenu);
                          }
                        });
                      },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                isTextFieldExpanded
                    ? IconButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            APIs.sendMessage(
                                widget.user, _textController.text, Type.text);
                            _textController.text = '';
                          }
                        },
                        icon: const Icon(Icons.send, color: Colors.blueAccent),
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final ImagePicker imagePicker = ImagePicker();
                              final XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.camera, imageQuality: 70);
                              if (image != null) {
                                log('Image Path: ${image.path}');
                                setState(() => _isUploading = true);
                                await APIs.sendChatImage(
                                    widget.user, File(image.path));
                                setState(() => _isUploading = false);
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.blueAccent,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final ImagePicker imagePicker = ImagePicker();
                              final List<XFile> images = await imagePicker
                                  .pickMultiImage(imageQuality: 70);
                              for (var i in images) {
                                setState(() => _isUploading = true);
                                await APIs.sendChatImage(
                                    widget.user, File(i.path));
                                setState(() => _isUploading = false);
                              }
                            },
                            icon: const Icon(
                              Icons.photo_library,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
