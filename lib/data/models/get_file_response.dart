class GetFileResponse {
  String? code;
  String? message;
  String? description;

  GetFileResponse({this.code, this.message, this.description});

  GetFileResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    description = json['description'];
  }
}
