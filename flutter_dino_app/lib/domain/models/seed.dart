import 'package:flutter/material.dart';
import 'package:flutter_dino_app/domain/models/seed_type.dart';
import 'package:flutter_dino_app/domain/models/seed_type_expand.dart';

@immutable
class Seed {
  final String collectionId;
  final String collectionName;
  final String id;
  final String seedType;
  final SeedTypeExpand expand;
  final String user;
  final int leafLevel;
  final int trunkLevel;
  final DateTime created;
  final DateTime updated;

  const Seed({
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.id,
    required this.seedType,
    required this.expand,
    required this.updated,
    required this.user,
    required this.leafLevel,
    required this.trunkLevel,
  });

  Seed upgradeLeaf() {
    return Seed(
      collectionId: collectionId,
      collectionName: collectionName,
      created: created,
      id: id,
      seedType: seedType,
      expand: expand,
      updated: DateTime.now(),
      user: user,
      leafLevel: leafLevel + 1,
      trunkLevel: trunkLevel,
    );
  }

  Seed upgradeTrunk() {
    return Seed(
      collectionId: collectionId,
      collectionName: collectionName,
      created: created,
      id: id,
      seedType: seedType,
      expand: expand,
      updated: DateTime.now(),
      user: user,
      leafLevel: leafLevel,
      trunkLevel: trunkLevel + 1,
    );
  }

  SeedType get seedTypeExpand => expand.seedType;
}
