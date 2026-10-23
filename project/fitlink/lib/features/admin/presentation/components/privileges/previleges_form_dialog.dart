import 'package:fitlink/core/model/privilege.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PrivilegeFormDialog extends StatefulWidget {
  const PrivilegeFormDialog({this.privilege});

  final Privilege? privilege;

  @override
  State<PrivilegeFormDialog> createState() => PrivilegeFormDialogState();
}

class PrivilegeFormDialogState extends State<PrivilegeFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.privilege?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.privilege?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final privilege = Privilege(
      id:
          widget.privilege?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: widget.privilege?.category ?? '',
      privilegeId: widget.privilege?.privilegeId ?? 0,
      isSystemPrivilege: widget.privilege?.isSystemPrivilege ?? false,
    );

    Navigator.pop(context, privilege);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: navyBlueLight,
      title: Text(
        widget.privilege == null ? 'Create privilege' : 'Edit privilege',
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(_nameController, 'Privilege name', 'e.g. USER_READ'),
              const SizedBox(height: 14),
              _field(
                _descriptionController,
                'Description',
                'What this privilege allows',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.privilege == null ? 'Create' : 'Save changes'),
        ),
      ],
    );
  }
}
