import 'package:optorg_mobile/utils/app_data_store.dart';

// +++++++++++++++++
// +++++++++++++++++
class User {
  int? code;
  String? message;
  String? token;
  Data? data;

  User({this.code, this.message, this.token, this.data});

  User.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

// +++++++++++++++++
// +++++++++++++++++
class Data {
  int? id;
  String? name;
  String? username;
  String? userjobs;
  String? surname;
  int? mgid;
  String? userrole;
  String? lancode;
  String? status;
  bool? locked;
  bool? changepassword;
  String? route;
  String? usertype;
  String? phone;
  String? email;
  String? currcode;
  String? mobile;
  String? tabposition;
  int? themeid;
  Theme? theme;

  bool? credentialsNonExpired;
  bool? accountNonExpired;
  bool? accountNonLocked;

  bool? enabled;

  Data(
      {this.id,
      this.name,
      this.username,
      this.userjobs,
      this.surname,
      this.mgid,
      this.userrole,
      this.lancode,
      this.status,
      this.locked,
      this.changepassword,
      this.route,
      this.usertype,
      this.phone,
      this.email,
      this.currcode,
      this.mobile,
      this.tabposition,
      this.themeid,
      this.theme,
      this.credentialsNonExpired,
      this.accountNonExpired,
      this.accountNonLocked,
      this.enabled});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    userjobs = json['userjobs'];
    surname = json['surname'];
    mgid = json['mgid'];
    userrole = json['userrole'];
    lancode = json['lancode'];
    status = json['status'];
    locked = json['locked'];
    changepassword = json['changepassword'];
    route = json['route'];
    usertype = json['usertype'];
    phone = json['phone'];
    email = json['email'];
    currcode = json['currcode'];
    mobile = json['mobile'];
    tabposition = json['tabposition'];
    themeid = json['themeid'];
    theme = json['theme'] != null ? new Theme.fromJson(json['theme']) : null;
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonExpired = json['accountNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['userjobs'] = this.userjobs;
    data['surname'] = this.surname;
    data['mgid'] = this.mgid;
    data['userrole'] = this.userrole;
    data['lancode'] = this.lancode;
    data['status'] = this.status;
    data['locked'] = this.locked;
    data['changepassword'] = this.changepassword;
    data['route'] = this.route;
    data['usertype'] = this.usertype;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['currcode'] = this.currcode;
    data['mobile'] = this.mobile;
    data['tabposition'] = this.tabposition;
    data['themeid'] = this.themeid;
    if (this.theme != null) {
      data['theme'] = this.theme!.toJson();
    }

    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonExpired'] = this.accountNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;

    data['enabled'] = this.enabled;
    return data;
  }
}

// +++++++++++++++++
// +++++++++++++++++
class Theme {
  int? themeid;
  String? themename;
  String? primarycolor;
  String? primarycolorlight;
  String? secondarycolor;
  String? bordercolor;
  String? textcolor;
  String? linkcolor;
  String? logo;
  String? fontface;

  Theme(
      {this.themeid,
      this.themename,
      this.primarycolor,
      this.primarycolorlight,
      this.secondarycolor,
      this.bordercolor,
      this.textcolor,
      this.linkcolor,
      this.logo,
      this.fontface});

  Theme.fromJson(Map<String, dynamic> json) {
    themeid = json['themeid'];
    themename = json['themename'];
    primarycolor = json['primarycolor'];
    primarycolorlight = json['primarycolorlight'];
    secondarycolor = json['secondarycolor'];
    bordercolor = json['bordercolor'];
    textcolor = json['textcolor'];
    linkcolor = json['linkcolor'];
    logo = json['logo'];
    fontface = json['fontface'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['themeid'] = this.themeid;
    data['themename'] = this.themename;
    data['primarycolor'] = this.primarycolor;
    data['primarycolorlight'] = this.primarycolorlight;
    data['secondarycolor'] = this.secondarycolor;
    data['bordercolor'] = this.bordercolor;
    data['textcolor'] = this.textcolor;
    data['linkcolor'] = this.linkcolor;
    data['logo'] = this.logo;
    data['fontface'] = this.fontface;
    return data;
  }

  static Future<User?> getConnectedUser() async {
    return await AppDataStore().getUserInfo();
  }
}
