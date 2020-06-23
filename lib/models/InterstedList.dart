class InterstedList {
  final String img_url;
  final String tag;
  final String title;

  InterstedList(this.img_url, this.title,this.tag);

  InterstedList.fromJson(Map<String, dynamic> json)
      : img_url = json['img_url'],title=json['title'],
        tag = json['tag'];

  Map<String, dynamic> toJson() =>
      {
        'img_url': img_url,
        'title':title,
        'email': tag,
      };
}