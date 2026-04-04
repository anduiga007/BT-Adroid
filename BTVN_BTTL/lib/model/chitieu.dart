class ChiTieu {
  final int? id;
  final String noiDung;
  final double soTien;
  final String ghiChu;
  final String ngay;

  ChiTieu({
    this.id,
    required this.noiDung,
    required this.soTien,
    required this.ghiChu,
    required this.ngay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noiDung': noiDung,
      'soTien': soTien,
      'ghiChu': ghiChu,
      'ngay': ngay,
    };
  }

  factory ChiTieu.fromMap(Map<String, dynamic> map) {
    return ChiTieu(
      id: map['id'],
      noiDung: map['noiDung'],
      soTien: map['soTien'],
      ghiChu: map['ghiChu'],
      ngay: map['ngay'],
    );
  }
}