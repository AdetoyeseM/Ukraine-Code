import 'package:flutter/material.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/screens/image/image_screen.dart';
import 'package:flutter_app1234/screens/profile/profile_screen.dart';

class PostWidget extends StatelessWidget {
  final UserModel user;
  final PostModel model;
  final int itemIndex;
  final bool showMenu;
  final bool navigateToUser;
  final VoidCallback onMenuClick;

  const PostWidget(
      {Key key,
      this.user,
      this.model,
      this.itemIndex,
      this.onMenuClick,
      this.navigateToUser = true,
      this.showMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: !navigateToUser
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userId: model.userId))),
                  child: Row(
                    children: [
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: user?.avatarUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.network(user.avatarUrl,
                                      fit: BoxFit.cover))
                              : Icon(Icons.person)),
                      SizedBox(width: 16),
                      Text(user?.username ?? ''),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!model.visibility)
                        Icon(Icons.visibility_off, color: Colors.grey),
                      if (showMenu)
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: onMenuClick,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          if (model.text.length > 0)
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 8),
              child: Text(model.text),
            ),
          if ((model.photos?.length ?? 0) > 0)
            _PostPhotosWidget(photos: model.photos, itemIndex: itemIndex),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(_timeAgoSinceDate(model.createdAt)),
              )),
          SizedBox(height: 8),
          Divider(),
        ],
      ),
    );
  }
}

class _PostPhotosWidget extends StatefulWidget {
  final int itemIndex;
  final List<String> photos;

  _PostPhotosWidget({Key key, this.photos, this.itemIndex}) : super(key: key);

  @override
  _PostPhotosWidgetState createState() => _PostPhotosWidgetState();
}

class _PostPhotosWidgetState extends State<_PostPhotosWidget> {
  PageController _controller;
  int currentPage = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: () {
        if (widget.photos.length > 1) {
          return Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                    controller: _controller,
                    itemCount: widget.photos.length,
                    onPageChanged: (value) =>
                        setState(() => currentPage = value),
                    itemBuilder: (contex, index) => _buildImage(widget.photos,
                        'image${widget.itemIndex}-$index', index)),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  margin: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.black.withOpacity(0.5)),
                  child: Text(
                    "${currentPage + 1}/${widget.photos.length}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
        } else {
          return _buildImage(widget.photos, 'image${widget.itemIndex}', 0);
        }
      }(),
    );
  }

  Widget _buildImage(List<String> photos, String heroName, int photoIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageScreen(
                photos: photos, heroName: heroName, photoIndex: photoIndex)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Hero(
              tag: heroName,
              child: Image.network(photos[photoIndex], fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

String _timeAgoSinceDate(int time, {bool numericDates = true}) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} months ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return 'A moment ago';
  } else {
    return 'Just now';
  }
}
