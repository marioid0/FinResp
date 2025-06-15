import '../database.dart';

class ViewGastoporusuarioTable extends SupabaseTable<ViewGastoporusuarioRow> {
  @override
  String get tableName => 'view_gastoporusuario';

  @override
  ViewGastoporusuarioRow createRow(Map<String, dynamic> data) =>
      ViewGastoporusuarioRow(data);
}

class ViewGastoporusuarioRow extends SupabaseDataRow {
  ViewGastoporusuarioRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewGastoporusuarioTable();

  String? get usuario => getField<String>('usuario');
  set usuario(String? value) => setField<String>('usuario', value);

  double? get totalSaida => getField<double>('total_saida');
  set totalSaida(double? value) => setField<double>('total_saida', value);
}
