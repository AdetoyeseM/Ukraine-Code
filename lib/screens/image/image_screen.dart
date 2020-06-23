import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final List<String> photos;
  final String heroName;
  final int photoIndex;

  const ImageScreen({Key key, this.photos, this.heroName, this.photoIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
                child: _PostPhotosWidget(
                    photos: photos, itemIndex: photoIndex, heroName: heroName)),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PostPhotosWidget extends StatefulWidget {
  final int itemIndex;
  final String heroName;
  final List<String> photos;

  _PostPhotosWidget({Key key, this.photos, this.itemIndex, this.heroName})
      : super(key: key);

  @override
  _PostPhotosWidgetState createState() => _PostPhotosWidgetState();
}

class _PostPhotosWidgetState extends State<_PostPhotosWidget> {
  PageController _controller;
  int currentPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.itemIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: PageView.builder(
                controller: _controller,
                itemCount: widget.photos.length,
                onPageChanged: (value) => setState(() => currentPage = value),
                itemBuilder: (contex, index) {
                  if (index == widget.itemIndex) {
                    return Hero(
                        tag: widget.heroName,
                        child: _buildImage(widget.photos[index]));
                  } else {
                    return _buildImage(widget.photos[index]);
                  }
                })),
        if (widget.photos.length > 1) Align(
            alignment: Alignment.topRight,
            child: Container(
                padding: const EdgeInsets.all(32.0),
                child: Text('${currentPage + 1}/${widget.photos.length}',
                    style: TextStyle(color: Colors.white))))
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Image.network(imageUrl),
    );
  }
}
