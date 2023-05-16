class RecentMusicModel {
  late String img;
  late String name;

  RecentMusicModel({required this.img, required this.name});

  static List<RecentMusicModel> getAll() => [
        RecentMusicModel(
            img: 'https://alfitude.com/wp-content/uploads/2018/09/COTIS.jpg',
            name: 'Cotis Reasons'),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            name: 'Damso - Dieu ne ment jamais'),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            name: 'Damso - Dieu ne ment jamais'),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            name: 'Damso - Dieu ne ment jamais'),
      ];
}
