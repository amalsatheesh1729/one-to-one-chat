class user
{

  String? uid;
  String? name;
  String? email;
  int? age ;
  String? photourl;

  user({required this.uid, required this.name,required this.age ,required this.email,required this.photourl});

  stringdynamicmaptouser(Map<String,dynamic> map)
  {
  return user(uid: map['uid'], name: name, age: age, email: email, photourl: photourl);
  }

  Map<String,dynamic> usertostringdynamicforfirestore()
  {
    return
        {
          'uid':uid,
          'name':name,
          'email':email,
          'age':age,
          'photourl':photourl
        };
  }

}

