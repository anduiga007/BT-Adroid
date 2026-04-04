class SanPham {
  final int? id;
  final String maSP;
  final String tenSP;
  final double donGia;
  final double giamGia;

  SanPham({
    this.id,
    required this.maSP,
    required this.tenSP,
    required this.donGia,
    required this.giamGia,
  });

  // Tính thuế nhập khẩu 10%
  double tinhThueNhapKhau() => donGia * 0.1;

  // Giá sau giảm
  double giaSauGiam() => donGia - giamGia;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'maSP': maSP,
      'tenSP': tenSP,
      'donGia': donGia,
      'giamGia': giamGia,
    };
  }

  factory SanPham.fromMap(Map<String, dynamic> map) {
    return SanPham(
      id: map['id'],
      maSP: map['maSP'],
      tenSP: map['tenSP'],
      donGia: map['donGia'],
      giamGia: map['giamGia'],
    );
  }
}