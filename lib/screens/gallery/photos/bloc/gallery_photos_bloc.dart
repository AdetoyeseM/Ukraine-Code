import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/src/asset.dart';

part 'gallery_photos_event.dart';
part 'gallery_photos_state.dart';

class GalleryPhotosBloc extends Bloc<GalleryPhotosEvent, GalleryPhotosState> {
  final ImageReposetory imageReposetory;
  final String title;
  final String username;

  GalleryPhotosBloc(this.imageReposetory, this.title, this.username);

  @override
  GalleryPhotosState get initialState => GalleryPhotosInitial();

  @override
  Stream<GalleryPhotosState> mapEventToState(
    GalleryPhotosEvent event,
  ) async* {
    if (event is GalleryPhotosSave) yield* _save(event);
  }

  Stream<GalleryPhotosState> _save(GalleryPhotosSave event) async* {
    yield GalleryPhotosLoading();
    final futures = event.images.map((image) async {
      var thumbData = await image.getThumbByteData(1024, 1024, quality: 100);

      await imageReposetory.uplaodGallaryImage(
          username,
          title,
          thumbData.buffer
              .asUint8List(thumbData.offsetInBytes, thumbData.lengthInBytes));
    });
    await Future.wait(futures);
    yield GalleryPhotosDone();
  }
}
