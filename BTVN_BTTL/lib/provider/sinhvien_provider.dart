import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/sinhvien.dart';

class SinhVienProvider extends ChangeNotifier {
  List<SinhVien> _sinhViens = [];
  List<SinhVien> _filtered = [];
  String _searchQuery = '';

  List<SinhVien> get sinhViens =>
      _searchQuery.isEmpty ? _sinhViens : _filtered;

  Future<void> loadSinhViens() async {
    _sinhViens = await DatabaseHelper().getSinhViens();
    _applySearch();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    _filtered = _sinhViens
        .where((sv) =>
    sv.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        sv.email.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> addSinhVien(SinhVien sv) async {
    await DatabaseHelper().insertSinhVien(sv);
    await loadSinhViens();
  }

  Future<void> deleteSinhVien(int id) async {
    await DatabaseHelper().deleteSinhVien(id);
    await loadSinhViens();
  }

  Future<void> updateSinhVien(SinhVien sv) async {
    await DatabaseHelper().updateSinhVien(sv);
    await loadSinhViens();
  }
}