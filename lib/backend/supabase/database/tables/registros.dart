import '../database.dart';

class RegistrosTable extends SupabaseTable<RegistrosRow> {
  @override
  String get tableName => 'registros';

  @override
  RegistrosRow createRow(Map<String, dynamic> data) => RegistrosRow(data);
}

class RegistrosRow extends SupabaseDataRow {
  RegistrosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegistrosTable();

  int get registroId => getField<int>('registro_id')!;
  set registroId(int value) => setField<int>('registro_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  String? get categoria => getField<String>('categoria');
  set categoria(String? value) => setField<String>('categoria', value);

  String? get tipo => getField<String>('tipo');
  set tipo(String? value) => setField<String>('tipo', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
