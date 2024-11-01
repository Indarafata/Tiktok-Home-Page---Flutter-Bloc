import 'dart:convert';

// Fungsi untuk mengonversi dari JSON string ke List<Tiktok>
List<Tiktok> tiktokFromJson(String str) =>
    List<Tiktok>.from(json.decode(str).map((x) => Tiktok.fromJson(x)));

// Fungsi untuk mengonversi List<Tiktok> kembali ke JSON string
String tiktokToJson(List<Tiktok> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tiktok {
  int? id;
  String? username;
  String? video;
  String? caption;
  int? favorite;
  int? comment;
  int? share;
  int? like;
  String? photo;
  String? sound;
  String? error;

  // Konstruktor utama, dengan tambahan parameter `error`
  Tiktok({
    this.id,
    this.username,
    this.video,
    this.caption,
    this.favorite,
    this.comment,
    this.share,
    this.like,
    this.photo,
    this.sound,
    this.error,
  });

  // Factory method untuk mengonversi dari JSON ke objek Tiktok
  factory Tiktok.fromJson(Map<String, dynamic> json) => Tiktok(
        id: json["id"],
        username: json["username"],
        video: json["video"],
        caption: json["caption"],
        favorite: json["favorite"],
        comment: json["comment"],
        share: json["share"],
        like: json["like"],
        photo: json["photo"],
        sound: json["sound"],
      );

  // Metode untuk mengonversi objek Tiktok ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "video": video,
        "caption": caption,
        "favorite": favorite,
        "comment": comment,
        "share": share,
        "like": like,
        "photo": photo,
        "sound": sound,
        "error": error
        // if (error != null) "error": error, // Tambahkan error ke JSON jika ada
      };
}
