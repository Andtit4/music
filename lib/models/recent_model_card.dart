class RecentMusicModel {
  late String img;
  late String name;
  late String title;
  late int duration;

  RecentMusicModel(
      {required this.img,
      required this.name,
      required this.title,
      required this.duration});

  static List<RecentMusicModel> getAll() => [
        RecentMusicModel(
            img: 'https://alfitude.com/wp-content/uploads/2018/09/COTIS.jpg',
            duration: 300000,
            title: "Reasons",
            name: 'Cotis'),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            duration: 300000,
            title: "Dieu ne ment jamais",
            name: 'Damso '),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            duration: 300000,
            title: "Dieu ne ment jamais",
            name: 'Damso '),
        RecentMusicModel(
            img: 'https://i.ytimg.com/vi/Usbd9lCu2ZI/maxresdefault.jpg',
            duration: 300000,
            title: "Dieu ne ment jamais",
            name: 'Damso '),
      ];
}
