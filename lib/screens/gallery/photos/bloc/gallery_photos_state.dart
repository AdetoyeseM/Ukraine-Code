part of 'gallery_photos_bloc.dart';

@immutable
abstract class GalleryPhotosState {}

class GalleryPhotosInitial extends GalleryPhotosState {}

class GalleryPhotosLoading extends GalleryPhotosState {}

class GalleryPhotosDone extends GalleryPhotosState {}
