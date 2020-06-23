class TrendingList {
  final String main_url;
  final String user_name;
  final String date;

  TrendingList(this.main_url, this.user_name,this.date);

  TrendingList.fromJson(Map<String, dynamic> json)
      : main_url = json['main_url'],user_name=json['user_name'],
        date = json['date'];

  Map<String, dynamic> toJson() =>
      {
        'main_url': main_url,
        'user_name':user_name,
        'date': date,
      };
}