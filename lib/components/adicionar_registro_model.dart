import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'adicionar_registro_widget.dart' show AdicionarRegistroWidget;
import 'package:flutter/material.dart';

class AdicionarRegistroModel extends FlutterFlowModel<AdicionarRegistroWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for descAdd widget.
  FocusNode? descAddFocusNode;
  TextEditingController? descAddTextController;
  String? Function(BuildContext, String?)? descAddTextControllerValidator;
  String? _descAddTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for valorAdd widget.
  FocusNode? valorAddFocusNode;
  TextEditingController? valorAddTextController;
  String? Function(BuildContext, String?)? valorAddTextControllerValidator;
  String? _valorAddTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for categoriaAdd widget.
  String? categoriaAddValue;
  FormFieldController<String>? categoriaAddValueController;
  // State field(s) for tipoAdd widget.
  String? tipoAddValue;
  FormFieldController<String>? tipoAddValueController;

  @override
  void initState(BuildContext context) {
    descAddTextControllerValidator = _descAddTextControllerValidator;
    valorAddTextControllerValidator = _valorAddTextControllerValidator;
  }

  @override
  void dispose() {
    descAddFocusNode?.dispose();
    descAddTextController?.dispose();

    valorAddFocusNode?.dispose();
    valorAddTextController?.dispose();
  }
}
