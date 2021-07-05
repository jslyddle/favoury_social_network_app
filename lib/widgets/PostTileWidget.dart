import 'package:flutter/material.dart';
import 'package:postme_app/pages/PostScreenPage.dart';
import 'package:postme_app/widgets/PostWidget.dart';



class PostTile extends StatefulWidget {
  final Post post;

  PostTile(this.post);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  displayFullPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: widget.post.postId, userId: widget.post.ownerId))).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.post.url),
          ),
        ),
      ),
    );
  }
}
