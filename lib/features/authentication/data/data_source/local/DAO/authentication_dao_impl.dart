import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/data/data_source/local/DAO/authentication_dao.dart';
import 'package:medired/features/authentication/data/models/authentication_model.dart';
import 'package:sembast/sembast.dart';

class AuthenticationDaoImpl implements AuthenticationDao {
  final Database _db;
  AuthenticationDaoImpl(this._db);

  final _userStore = intMapStoreFactory.store(Collections.authentication);

  @override
  Future<void> insertAuthentication(AuthenticationModel authModel) async {
    await _userStore.add(_db, authModel.toJson());
  }

  @override
  Future<void> deleteAuthentication(AuthenticationModel authModel) async {
    var finder = Finder(filter: Filter.byKey(authModel.id));

    await _userStore.delete(
      _db,
      finder: finder,
    );
  }

  @override
  Future<void> updateAuthentication(AuthenticationModel authModel) async {
    var finder = Finder(filter: Filter.byKey(authModel.id));

    await _userStore.update(
      _db,
      authModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<List<AuthenticationModel>> getAllSortedByName() async {
    // var finder = Finder(sortOrders: [SortOrder('username')]);

    var recordSnapshots = await _userStore.find(_db);

    return recordSnapshots.map((snapshot) {
      var authModel = AuthenticationModel.fromJson(snapshot.value);

      return AuthenticationModel.fromEntity(
        authModel.copyWith(id: snapshot.key),
      );
    }).toList();
  }
}
