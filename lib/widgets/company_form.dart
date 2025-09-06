import 'dart:io';
import 'package:crud_api/models/company_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompanyForm extends StatefulWidget {
  final CompanyModel? initialCompany;   // pass this for edit, null for create
  final Future<void> Function(CompanyModel) onSubmit; // callback for create/update

  const CompanyForm({
    super.key,
    this.initialCompany,
    required this.onSubmit,
  });

  @override
  State<CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  File? _newImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialCompany?.companyName ?? "");
    _emailCtrl = TextEditingController(text: widget.initialCompany?.email ?? "");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  ImageProvider? _currentImage() {
    if (_newImage != null) return FileImage(_newImage!);

    final avatar = widget.initialCompany?.avatar;
    if (avatar == null || avatar.isEmpty) return null;

    if (avatar.startsWith("http")) {
      return NetworkImage(avatar);
    } else if (File(avatar).existsSync()) {
      return FileImage(File(avatar));
    }
    return null;
  }

  Future<void> _pickImage(ImageSource src) async {
    final file = await _picker.pickImage(source: src);
    if (file != null) {
      setState(() => _newImage = File(file.path));
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final company = CompanyModel(
        id: widget.initialCompany?.id, // keep id for edit
        companyName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        avatar: _newImage?.path ?? widget.initialCompany?.avatar,
      );

      await widget.onSubmit(company);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showImagePicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choose Logo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text("Pick from Gallery"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text("Pick from Camera"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialCompany != null;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _currentImage(),
            backgroundColor: Colors.pinkAccent,
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: _showImagePicker,
            child: Text(
              isEdit ? "Change Company Logo" : "Add Company Logo",
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // name
          TextFormField(
            controller: _nameCtrl,
            validator: (v) => (v == null || v.isEmpty) ? "Enter company name" : null,
            decoration: InputDecoration(
              hintText: "Company Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),

          // email
          TextFormField(
            controller: _emailCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return "Enter company email";
              if (!EmailValidator.validate(v)) return "Invalid email";
              return null;
            },
            decoration: InputDecoration(
              hintText: "Company Email",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // submit button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    isEdit ? "Save Changes" : "Create Company",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
