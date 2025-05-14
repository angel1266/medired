enum ImageType {
  slide,
  slide2,
}

final Map<String, ImageType> stringImageType = {
  'assets/images/slide.png': ImageType.slide,
  'assets/images/doc.png': ImageType.slide2,
//  "Miembro": ImageType.slide2,
};

final Map<ImageType, String> imageTypeToString = {
  ImageType.slide: 'assets/images/slide.png',
  ImageType.slide2: 'assets/images/doc.png',
};
