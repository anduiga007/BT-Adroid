import 'package:flutter/material.dart';
import '../database/sanpham_db_helper.dart';
import '../model/sanpham.dart';

class SanPhamProvider extends ChangeNotifier {
  List<SanPham> _sanPhams = [];

  List<SanPham> get sanPhams => _sanPhams;

  Future<void> loadSanPhams() async {
    _sanPhams = await SanPhamDatabaseHelper().getSanPhams();
    notifyListeners();
  }

  Future<void> addSanPham(SanPham sp) async {
    await SanPhamDatabaseHelper().insertSanPham(sp);
    await loadSanPhams();
  }

  Future<void> deleteSanPham(int id) async {
    await SanPhamDatabaseHelper().deleteSanPham(id);
    await loadSanPhams();
  }

  Future<void> updateSanPham(SanPham sp) async {
    await SanPhamDatabaseHelper().updateSanPham(sp);
    await loadSanPhams();
  }
}