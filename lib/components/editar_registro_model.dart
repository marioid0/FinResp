import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'editar_registro_widget.dart' show EditarRegistroWidget;
import 'package:flutter/material.dart';

class EditarRegistroModel extends FlutterFlowModel<EditarRegistroWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for registro widget.
  FocusNode? registroFocusNode;
  TextEditingController? registroTextController;
  String? Function(BuildContext, String?)? registroTextControllerValidator;
  // State field(s) for valor widget.
  FocusNode? valorFocusNode;
  TextEditingController? valorTextController;
  String? Function(BuildContext, String?)? valorTextControllerValidator;
  // State field(s) for categoria widget.
  String? categoriaValue;
  FormFieldController<String>? categoriaValueController;
  // State field(s) for tipo widget.
  String? tipoValue;
  FormFieldController<String>? tipoValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    registroFocusNode?.dispose();
    registroTextController?.dispose();

    valorFocusNode?.dispose();
    valorTextController?.dispose();
  }
}
