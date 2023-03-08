import 'dart:convert';

import 'package:firebase_dart/firebase_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

import '../bin/configurations.dart';
import '../utils/checker.dart';
import '../utils/get_date.dart';

class API {
  Handler get userHandler {
    var router = Router();

    //! Create User Method
    router.post('/users', (Request request) async {
      //? Get request data and parse to Map
      var data = await request.readAsString().then((value) {
        return jsonDecode(value);
      });

      //? Check data inputs
      String checkResponse = checker(['username', 'age'], data);
      if (checkResponse != 'success') {
        return Response.notFound(
          jsonEncode({'success': false, 'error': checkResponse}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      //? Get Database
      final DatabaseReference database = await getDatabase();

      //? Create unique id and get date
      String id = Uuid().v1();
      String createdAt = getFullDate();

      //? Set new item to Database
      await database.child(id).set({
        "id": id,
        "username": data["username"],
        "age": data["age"],
        "createdAt": createdAt,
      });

      //? Return the response
      return Response.ok(
        jsonEncode({
          'success': true,
          "id": id,
          "createdAt": createdAt,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    });

    //! Read Users Method
    router.get('/users', (Request request) async {
      //? Get Database
      DatabaseReference database = await getDatabase();

      //? Get items;
      dynamic data;
      await database.once().then((response) {
        data = response.value;
      });

      //? Return the response
      return Response.ok(
        json.encode(data),
        headers: {'content-type': 'application/users'},
      );
    });

    //! Read User Method
    router.get('/users/<id>', (Request request) async {
      //? Get id parameter
      final id = request.params["id"] ?? '';

      //? Get Database
      DatabaseReference database = await getDatabase();

      //? Get item
      dynamic data;
      await database.child(id).once().then((response) {
        data = response.value;
      });

      //? Return the response
      return Response.ok(
        json.encode(data),
        headers: {'content-type': 'application/users'},
      );
    });

    //! Update User Method
    router.put('/users/<id>', (Request request) async {
      //? Get id parameter
      final id = request.params["id"] ?? '';

      //? Get request data and parse to Map
      Map<String, dynamic> data = await request.readAsString().then((value) {
        return jsonDecode(value);
      });

      //? Get Database
      DatabaseReference database = await getDatabase();

      //? Create updates list and get date
      final List<String> updates = [];
      String updatedAt = getFullDate();

      //? Update item values
      data.forEach((key, value) async {
        if (value != null) {
          updates.add(key);
          await database.child(id).update({
            key: value,
            "updatedAt": updatedAt,
          });
        }
      });

      //? Return the response
      return Response.ok(
        jsonEncode({
          'success': true,
          "id": id,
          "updatedAt": updatedAt,
          "updates": updates,
        }),
        headers: {'Content-Type': 'application/users'},
      );
    });

    //! Delete User Method
    router.delete('/users/<id>', (Request request) async {
      //? Get id
      final id = request.params["id"] ?? '';

      //? Get Database
      DatabaseReference database = await getDatabase();

      //? Delete item from Database
      await database.child(id).remove();

      //? Return the response
      return Response.ok(
        jsonEncode({
          'success': true,
        }),
        headers: {'Content-Type': 'application/users'},
      );
    });

    //! Delete Users Method
    router.delete('/users', (Request requiest) async {
      //? Get Database
      DatabaseReference database = await getDatabase();

      //? Delete items
      await database.remove();

      //? Return the response
      return Response.ok(
        jsonEncode({
          'success': true,
        }),
        headers: {'Content-Type': 'application/users'},
      );
    });

    return router;
  }

  //! Get Database Method
  Future<DatabaseReference> getDatabase() async {
    FirebaseApp app = await initApp();
    final FirebaseDatabase db = FirebaseDatabase(
      app: app,
      databaseURL: Configurations.databaseUrl,
    );
    return db.reference().child('users');
  }

  //! Initialize Firebase App Method
  Future<FirebaseApp> initApp() async {
    late FirebaseApp app;

    try {
      app = Firebase.app();
    } catch (e) {
      app = await Firebase.initializeApp(
        options: FirebaseOptions.fromMap(Configurations.firebaseConfig),
      );
    }

    return app;
  }
}
