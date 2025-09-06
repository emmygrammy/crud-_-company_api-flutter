import 'package:crud_api/widgets/company_form.dart';
import 'package:flutter/material.dart';
import 'package:crud_api/models/company_model.dart';
import 'package:crud_api/services/company_services.dart';


class EditCompanyScreen extends StatelessWidget {
  final CompanyModel company;
  const EditCompanyScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Company")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CompanyForm(
          initialCompany: company,
          onSubmit: (updated) async {
            await CompanyServices().updateCompany(updated);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Company updated!")),
            );
          },
        ),
      ),
    );
  }
}
