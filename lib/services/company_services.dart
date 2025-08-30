import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crud_api/models/company_model.dart';

class CompanyServices {
  final String baseUrl = 'https://68af5c97b91dfcdd62bc2300.mockapi.io/api/v1/';

  Future<List<CompanyModel>> getCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companyNames'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<void> createCompany(CompanyModel company) async {
    final response = await http.post(
      Uri.parse('$baseUrl/companyNames'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(company.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
    } else {
      throw Exception('Failed to create company');
    }
  }

  Future<void> updateCompany(CompanyModel company) async {
    final response = await http.put(
      Uri.parse('$baseUrl/companyNames/${company.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(company.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
    } else {
      throw Exception('Failed to update company');
    }
  }

  Future<void> deleteCompany(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/companyNames/$id'),
    );
    if (response.statusCode == 200) {
      print('Company deleted successfully');
    } else {
      throw Exception('Failed to delete company');
    }
  }
    
}
