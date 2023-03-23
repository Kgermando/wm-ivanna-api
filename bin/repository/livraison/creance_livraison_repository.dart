import 'package:postgres/postgres.dart';

import '../../models/restaurant/creance_restaurant_model.dart';
 

class CreanceLivraisonRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  CreanceLivraisonRepository(this.executor, this.tableName);


  Future<List<CreanceRestaurantModel>> getAllData(String business) async {
    var data = <CreanceRestaurantModel>{};

    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(CreanceRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(CreanceRestaurantModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
        "INSERT INTO $tableName (id, cart, client,"
        "nom_client, telephone, addresse, delai_paiement,"
        "succursale, signature, created, business)"
        "VALUES (nextval('creance_livraisons_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8, @9, @10)",
        substitutionValues: {
          '1': data.cart,
          '2': data.client,
          '3': data.nomClient,
          '4': data.telephone,
          '5': data.addresse,
          '6': data.delaiPaiement,
          '7': data.succursale,
          '8': data.signature,
          '9': data.created,
          '10': data.business
        }
      );
    });
  }

  Future<void> update(CreanceRestaurantModel data) async {
    await executor.query("""UPDATE $tableName
      SET cart = @1, client = @2, nom_client = @3,
      telephone = @4, addresse = @5, delai_paiement = @6, succursale = @7,
      signature = @8, created = @9, business = @10 WHERE id = @11""", substitutionValues: {
      '1': data.cart,
      '2': data.client,
      '3': data.nomClient,
      '4': data.telephone,
      '5': data.addresse,
      '6': data.delaiPaiement,
      '7': data.succursale,
      '8': data.signature,
      '9': data.created,
      '10': data.business,
      '11': data.id
    });
  } 

  deleteData(int id) async {
    try {
      await executor.transaction((conn) async {
        // ignore: unused_local_variable
        var result = await conn.execute('DELETE FROM $tableName WHERE id=$id;');
      });
    } catch (e) {
      'erreur $e';
    }
  }

  Future<CreanceRestaurantModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return CreanceRestaurantModel(
      id: data[0][0],
      cart: data[0][1],
      client: data[0][2],
      nomClient: data[0][3],
      telephone: data[0][4],
      addresse: data[0][5],
      delaiPaiement: data[0][6],
      succursale: data[0][7],
      signature: data[0][8],
      created: data[0][9],
      business: data[0][10]
    );
  } 
}