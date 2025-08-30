import 'dart:io';

import 'package:crud_api/models/company_model.dart';
import 'package:crud_api/services/company_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;


  //?pick image from gallary
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //?image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //?create company
  Future<void> _createCompany() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please pick an image'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await CompanyServices().createCompany(
          CompanyModel(
            companyName: _companyNameController.text,
            email: _companyEmailController.text,
            avatar: _imageFile!.path,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company created successfully!')),
        );

        // optional: clear form after success
        _companyNameController.clear();
        _companyEmailController.clear();
        setState(() {
          _imageFile = null;
        });
        Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Company'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  SizedBox(height: 3,),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Company Logo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _pickImage();
                                },
                                child: Text('Pick from Gallery'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _pickImageFromCamera();
                                },
                                child: Text('Pick from Camera'),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (_imageFile != null) {
                        //? upload image to server
                      }

                    },
                    child: Text('Add Company Logo',
                    style: TextStyle(color: Colors.pinkAccent, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  //? company name
                  TextFormField(
                    controller: _companyNameController,
        
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a company name';
                      }
                      return null;
                    },
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Enter Company Name',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pinkAccent, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  //? company email
                  TextFormField(
                    controller: _companyEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a company email';
                      }
                      else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Company Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pinkAccent),

                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  //? create company button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createCompany,
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading ? CircularProgressIndicator() : 
                    Text('Create Company', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
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
}