import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/core/utils/currency_formatter.dart';
import '/core/widgets/transaction_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adicionar_registro_model.dart';
export 'adicionar_registro_model.dart';

class AdicionarRegistroWidget extends StatefulWidget {
  const AdicionarRegistroWidget({super.key});

  @override
  State<AdicionarRegistroWidget> createState() =>
      _AdicionarRegistroWidgetState();
}

class _AdicionarRegistroWidgetState extends State<AdicionarRegistroWidget> {
  late AdicionarRegistroModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdicionarRegistroModel());

    _model.descAddTextController ??= TextEditingController();
    _model.descAddFocusNode ??= FocusNode();

    _model.valorAddTextController ??= TextEditingController();
    _model.valorAddFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 400,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nova Transação',
                          style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Type Selection
                        Text(
                          'Tipo de Transação',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTypeSelector(
                                  'Entrada',
                                  Icons.trending_up,
                                  Colors.green,
                                  _model.tipoAddValue == 'Entrada',
                                ),
                              ),
                              Expanded(
                                child: _buildTypeSelector(
                                  'Saída',
                                  Icons.trending_down,
                                  Colors.red,
                                  _model.tipoAddValue == 'Saída',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description Field
                        Text(
                          'Descrição',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.descAddTextController,
                          focusNode: _model.descAddFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Ex: Compra no supermercado',
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          validator: _model.descAddTextControllerValidator.asValidator(context),
                        ),

                        const SizedBox(height: 16),

                        // Value Field
                        Text(
                          'Valor (R\$)',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.valorAddTextController,
                          focusNode: _model.valorAddFocusNode,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: InputDecoration(
                            hintText: '0,00',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          validator: _model.valorAddTextControllerValidator.asValidator(context),
                        ),

                        const SizedBox(height: 16),

                        // Category Field
                        Text(
                          'Categoria',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FlutterFlowDropDown<String>(
                          controller: _model.categoriaAddValueController ??=
                              FormFieldController<String>(null),
                          options: const [
                            'Aluguel',
                            'Supermercado',
                            'Delivery',
                            'Farmácia',
                            'Academia',
                            'Salário',
                            'Rendimento Extra',
                            'Gasolina',
                            'Lazer',
                            'Estudos'
                          ],
                          onChanged: (val) => safeSetState(
                              () => _model.categoriaAddValue = val),
                          width: double.infinity,
                          height: 56.0,
                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                          hintText: 'Selecione a categoria...',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          elevation: 2.0,
                          borderColor: FlutterFlowTheme.of(context).alternate,
                          borderWidth: 1.0,
                          borderRadius: 12.0,
                          margin: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                          hidesUnderline: true,
                          isOverButton: true,
                          isSearchable: false,
                          isMultiSelect: false,
                        ),

                        // Category Preview
                        if (_model.categoriaAddValue != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                TransactionCategoryIcon(
                                  category: _model.categoriaAddValue!,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _model.categoriaAddValue!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      text: 'Cancelar',
                      options: FFButtonOptions(
                        height: 44.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Colors.transparent,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.readexPro(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_model.formKey.currentState == null ||
                            !_model.formKey.currentState!.validate()) {
                          return;
                        }
                        if (_model.categoriaAddValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor, selecione uma categoria')),
                          );
                          return;
                        }
                        if (_model.tipoAddValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor, selecione o tipo da transação')),
                          );
                          return;
                        }

                        try {
                          await RegistrosTable().insert({
                            'descricao': _model.descAddTextController.text,
                            'categoria': _model.categoriaAddValue,
                            'tipo': _model.tipoAddValue,
                            'valor': double.tryParse(_model.valorAddTextController.text),
                            'user_id': currentUserUid,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Transação adicionada com sucesso!'),
                                ],
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar transação: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      text: 'Salvar Transação',
                      options: FFButtonOptions(
                        height: 44.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.readexPro(),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                        elevation: 2.0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(String type, IconData icon, Color color, bool isSelected) {
    return InkWell(
      onTap: () => safeSetState(() {
        _model.tipoAddValue = type;
        _model.tipoAddValueController?.value = type;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: color, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : FlutterFlowTheme.of(context).secondaryText,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? color : FlutterFlowTheme.of(context).secondaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}