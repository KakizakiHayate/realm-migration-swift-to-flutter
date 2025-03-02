import 'package:realm/realm.dart';

part 'user.realm.dart';

@RealmModel()
class _User {
  @PrimaryKey()
  late String id;

  late String name;

  late int age;
}
