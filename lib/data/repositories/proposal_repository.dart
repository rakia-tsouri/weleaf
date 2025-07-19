import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';

class ProposalsRepository extends AppRepository {
  final String _baseUrl = 'https://demo-backend-utina.teamwill-digital.com';

  Future<ApiResponse<ProposalListResponse>> getProposalsList({
    int offset = 0,
    int limit = 10,
    String? status,
  }) async {
    try {
      final response = await dioWithToken.get(
        '$_baseUrl/proposal-service/api/proposal',
        queryParameters: {
          'branchid': '',
          'brokername': '',
          'clientname': '',
          'ctphase': '',
          'ctreference': '',
          'ctstatus': '',
          'datemax': '',
          'datemin': '',
          'flagPropWithCtreference': 'false',
          'marketingid': '',
          'ctstatus': status ?? '',
          'mfid': 0,
          'network': '',
          'offerid': '',
          'prcode': '',
          'propreference': '',
          'tpauthdetailid': 0,
          'tpauthid': 0,
          'tpidbroker': '',
          'tpidclient': 0,
          'tprefbroker': '',
          'tpreference': '',
          'offset': offset,
          'limit': limit,
        },
      );

      final proposalsResponse = ProposalListResponse.fromJson(response.data);

      // Charger les images pour les premières propositions
      if (proposalsResponse.list != null) {
        for (final proposal in proposalsResponse.list!.take(3)) {
          if (proposal.assetpictureurl != null && proposal.assetpictureurl!.isNotEmpty) {
            final imageResponse = await _getFile(proposal.assetpictureurl!);
            if (imageResponse.isSuccess() && imageResponse.data != null) {
              proposal.imageBytes = base64Decode(imageResponse.data!);
            }
          }
        }
      }

      return ApiResponse.completed(proposalsResponse);
    } on DioException catch (e) {
      print('Error fetching proposals: ${e.message}');
      return ApiResponse.error(e.response?.data?['message'] ?? 'Failed to load proposals');
    } catch (e) {
      print('Error fetching proposals: $e');
      return ApiResponse.error('Failed to load proposals');
    }
  }


  Future<ApiResponse<ProposalDetailsResponse>> getProposalDetails(String proposalId) async {
    try {
      final response = await dioWithToken.get(
        '$_baseUrl/api/proposal/$proposalId',
      );

      final detailsResponse = ProposalDetailsResponse.fromJson(response.data);

      // Charger l'image si disponible
      if (detailsResponse.data?.assetpictureurl != null && detailsResponse.data!.assetpictureurl!.isNotEmpty) {
        final imageResponse = await _getFile(detailsResponse.data!.assetpictureurl!);
        if (imageResponse.isSuccess() && imageResponse.data != null) {
          detailsResponse.data!.assetpictureBase64 = imageResponse.data;
        }
      }

      return ApiResponse.completed(detailsResponse);
    } on DioException catch (e) {
      print('Error fetching proposal details: ${e.message}');
      return ApiResponse.error(e.response?.data?['message'] ?? 'Failed to load proposal details');
    } catch (e) {
      print('Error fetching proposal details: $e');
      return ApiResponse.error('Failed to load proposal details');
    }
  }

  Future<ApiResponse<String>> _getFile(String fileName) async {
    try {
      final response = await dioWithToken.post(
        '$_baseUrl/document-service/api/getfile/$fileName',
      );

      String? fileData = response.data['description'];

      // Nettoyer la chaîne base64 si nécessaire
      if (fileData != null && fileData.contains(',')) {
        fileData = fileData.split(',').last;
      }

      return ApiResponse.completed(fileData);
    } on DioException catch (e) {
      print('Error fetching file: ${e.message}');
      return ApiResponse.error('Failed to load file');
    } catch (e) {
      print('Error fetching file: $e');
      return ApiResponse.error('Failed to load file');
    }
  }

  Future<ApiResponse<void>> updateProposalStatus({
    required String proposalId,
    required String status,
  }) async {
    try {
      await dioWithToken.put(
        '$_baseUrl/api/proposals/$proposalId/status',
        data: {'status': status},
      );

      return ApiResponse.completed(null);
    } on DioException catch (e) {
      print('Error updating proposal status: ${e.message}');
      return ApiResponse.error(e.response?.data?['message'] ?? 'Failed to update status');
    } catch (e) {
      print('Error updating proposal status: $e');
      return ApiResponse.error('Failed to update status');
    }
  }

  Future<ApiResponse<ProposalDetailsResponse>> createProposal(
      Map<String, dynamic> proposalData,
      ) async {
    try {
      final response = await dioWithToken.post(
        '$_baseUrl/api/proposals',
        data: proposalData,
      );

      final detailsResponse = ProposalDetailsResponse.fromJson(response.data);
      return ApiResponse.completed(detailsResponse);
    } on DioException catch (e) {
      print('Error creating proposal: ${e.message}');
      return ApiResponse.error(e.response?.data?['message'] ?? 'Failed to create proposal');
    } catch (e) {
      print('Error creating proposal: $e');
      return ApiResponse.error('Failed to create proposal');
    }
  }
}
