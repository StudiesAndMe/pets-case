import 'dart:io' as io;
import 'dart:math';

import 'package:glados/glados.dart';
import 'package:moor/ffi.dart';

import 'package:test/test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pets/pets_objects/pets_objects.dart';
import 'package:pets/repositories/pets_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  group("Simple pets repository tests", () {
    late PetsDatabase db;
    String dbPath = any.letters(Random(), 10).value + ".db";

    setUpAll(() {
      db = PetsDatabase(dbPath);
    });

    tearDownAll(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      await db.close();
      final file = io.File(p.join(dbFolder.path, dbPath));
      await file.delete();
    });

    test(
        "An owner and their single cat can be inserted and retrieved correctly",
        () async {
      var owner = Owner(Uuid().v4(), "Jon", 39);
      var pet = Pet(
          Uuid().v4(), owner.id, Gender.male, "Garfield", 9, InnerPet.cat());

      await db.insertOwner(owner);
      await db.insertPet(pet);
      var retrievedOwner = await db.getOwner(owner.id);
      var retrievedPet = await db.getPet(pet.id);
      expect(retrievedOwner, equals(owner));
      expect(retrievedPet, equals(pet));
    });

    /// test("We cannot insert two owners with the same id", () async {
    /// });

    /// test("We cannot insert a pet without an valid owner", () async {
    /// });
  });
}
