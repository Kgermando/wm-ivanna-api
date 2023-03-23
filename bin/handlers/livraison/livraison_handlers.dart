import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
  
import '../../models/restaurant/restaurant_model.dart';
import '../../repository/repository.dart';

class LivraisonHandlers {
  final Repository repos;

  LivraisonHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>/', (Request request, String business) async {
      List<RestaurantModel> data = await repos.livraisons.getAllData(business);
      return Response.ok(jsonEncode(data));
    });
 
    router.get('/<id>', (Request request, String id) async {
      late RestaurantModel dataItem;
      try {
        dataItem = await repos.livraisons.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.post('/insert-new-livraison', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      RestaurantModel dataItem = RestaurantModel(
        identifiant: input['identifiant'],
        table: input['table'],
        qty: input['qty'],
        price: input['price'],
        unite: input['unite'],
        statutCommande: input['statutCommande'],
        succursale: input['succursale'],
        signature: input['signature'],
        created: DateTime.parse(input['created']), 
        business: input['business'],
      );

      try {
        await repos.livraisons.insertData(dataItem);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.put('/update-livraison/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = RestaurantModel.fromJson(input);
      RestaurantModel? dataItem = await repos.livraisons.getFromId(editH.id!);

      if (input['identifiant'] != null) {
        dataItem.identifiant = input['identifiant'];
      }
      if (input['table'] != null) {
        dataItem.table = input['table'];
      }
      if (input['qty'] != null) {
        dataItem.qty = input['qty'];
      }
      if (input['price'] != null) {
        dataItem.price = input['price'];
      }
      if (input['unite'] != null) {
        dataItem.unite = input['unite'];
      }
      if (input['statutCommande'] != null) {
        dataItem.statutCommande = input['statutCommande'];
      } 
      if (input['succursale'] != null) {
        dataItem.succursale = input['succursale'];
      }
      if (input['signature'] != null) {
        dataItem.signature = input['signature'];
      }
      if (input['created'] != null) {
        dataItem.created = DateTime.parse(input['created']);
      } 
      if (input['business'] != null) {
        dataItem.business = input['business'];
      }

      repos.livraisons.update(dataItem);
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.delete('/delete-livraison/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.tableLivraisons.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('La Page livraison n\'est pas trouvé'),
    );

    return router;
  }
}
