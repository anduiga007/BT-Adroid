import 'package:flutter/material.dart';
import '../database/chitieu_db_helper.dart';
import '../model/chitieu.dart';

class ChiTieuProvider extends ChangeNotifier {
  List<ChiTieu> _chiTieus = [];

  List<ChiTieu> get chiTieus => _chiTieus;

  double get tongChiTieu =>
      _chiTieus.fold(0, (sum, ct) => sum + ct.soTien);

  Future<void> loadChiTieus() async {
    _chiTieus = await ChiTieuDatabaseHelper().getChiTieus();
    notifyListeners();
  }

  Future<void> addChiTieu(ChiTieu ct) async {
    await ChiTieuDatabaseHelper().insertChiTieu(ct);
    await loadChiTieus();
  }

  Future<void> deleteChiTieu(int id) async {
    await ChiTieuDatabaseHelper().deleteChiTieu(id);
    await loadChiTieus();
  }

  Future<void> updateChiTieu(ChiTieu ct) async {
    await ChiTieuDatabaseHelper().updateChiTieu(ct);
    await loadChiTieus();
  }
}