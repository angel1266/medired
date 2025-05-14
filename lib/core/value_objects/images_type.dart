enum ImagesType {
  grupo1,
  //group2,
}

final Map<List<String>, ImagesType> stringimagesType = {
  ['image2.png', 'image3.png', 'image4.png', 'image5.png', 'image6.png']:
      ImagesType.grupo1,
};

final Map<ImagesType, List<String>> imagesTypeToString = {
  ImagesType.grupo1: [
    'image2.png',
    'image3.png',
    'image4.png',
    'image5.png',
    'image6.png'
  ],
};
