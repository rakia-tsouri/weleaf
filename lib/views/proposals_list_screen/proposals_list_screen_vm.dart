import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/data/repositories/proposal_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class ProposalsListScreenVM extends ChangeNotifier {
  final ProposalsRepository proposalsRepository = ProposalsRepository();
  User? connectedUser;

  Future<ApiResponse<ProposalListResponse>> getListOfProposals({
    required int offset,
  }) async {
    connectedUser = await AppDataStore().getUserInfo();
    if (connectedUser != null) {
      final response = await proposalsRepository.getProposalsList(offset: offset);
      if (response.isSuccess()) {
        return response;
      }
    }
    return ApiResponse.error("ERROR_OCCURED");
  }

  Future<ApiResponse<ProposalDetailsResponse>> getProposalDetails({
    required int proposalId,
  }) async {
    final response = await proposalsRepository.getProposalDetails(
      proposalid: proposalId,
    );

    if (response.isSuccess()) {
      if (response.data != null &&
          response.data!.data != null &&
          response.data!.data!.assets != null) {
        final assetId = response.data!.data!.assets!.first.assetid;
        if (assetId != null) {
          final responseAssetServices = await getAssetServicesList(
            assetId: assetId,
          );
          if (responseAssetServices.isSuccess() &&
              responseAssetServices.data != null) {
            response.data!.data!.assetServiceList =
                responseAssetServices.data!.list;
          }
        }
      }
      return response;
    }
    return ApiResponse.error("ERROR_OCCURED");
  }

  Future<ApiResponse<AssetServicesResponse>> getAssetServicesList({
    required int assetId,
  }) async {
    final response = await proposalsRepository.getAssetSeriveList(
      assetId: assetId,
    );
    if (response.isSuccess()) {
      return response;
    }
    return ApiResponse.error("ERROR_OCCURED");
  }
}
