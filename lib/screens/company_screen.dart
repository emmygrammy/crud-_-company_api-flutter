import 'package:crud_api/models/company_model.dart';
import 'package:crud_api/screens/create_company_screen.dart';
import 'package:crud_api/services/company_services.dart';
import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  List<CompanyModel> companies = [];

  Future<void> _loadCompanies() async {
    final freshData = await CompanyServices().getCompanies();
    setState(() {
      companies = freshData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Companies'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // navigate to create company and refresh when coming back
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCompanyScreen()),
          );
          _loadCompanies(); // refresh list after returning
        },
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<CompanyModel>>(
        future: CompanyServices().getCompanies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No companies found'));
          } else {
            companies = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _loadCompanies,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.grey[200],
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(companies[index].avatar ?? ''),
                    ),
                    title: Text(companies[index].companyName ?? 'No Name'),
                    subtitle: Text(companies[index].email ?? 'No Email'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.pinkAccent),
                          onPressed: () {
                            // edit logic here
                          },
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.blue),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Company'),
                                content: const Text(
                                    'Are you sure you want to delete this company?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await CompanyServices()
                                  .deleteCompany(companies[index].id!);
                              setState(() {
                                companies.removeAt(index);
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Company deleted successfully')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
