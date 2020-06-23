part of 'gallery_photos_bloc.dart';

@immutable
abstract class GalleryPhotosEvent {}

class GalleryPhotosSave extends GalleryPhotosEvent {
  final List<Asset> images;

  GalleryPhotosSave(this.images);
}