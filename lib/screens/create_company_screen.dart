import 'package:crud_api/widgets/company_form.dart';
import 'package:flutter/material.dart';
// import 'package:crud_api/models/company_model.dart';
import 'package:crud_api/services/company_services.dart';


class CreateCompanyScreen extends StatelessWidget {
  const CreateCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Company")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CompanyForm(
          onSubmit: (company) async {
            await CompanyServices().createCompany(company);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Company created!")),
            );
          },
        ),
      ),
    );
  }
}
