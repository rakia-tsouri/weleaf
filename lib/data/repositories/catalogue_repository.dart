import 'package:dio/dio.dart';
import 'package:optorg_mobile/pages/catalogue_page.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class CatalogRepository extends AppRepository {
  Future<List<CatalogItem>> fetchCatalogItems() async {
    try {
      final appStorage = AppDataStore();
      final token = await appStorage.getToken();

      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        'https://demo-backend-utina.teamwill-digital.com/assetconfig-service/api/prGetAssetCatalogByKeyword',
        queryParameters: {
          'currcode': 'MAD',
          'filters': '',
          'flagwebshop': false,
          'keyword': '',
          'mcid': 0,
          'mgid': 6,
          'networkcode': 'SCANNIA',
          'tpidbroker': 0,
          'tpidmanufacturer': '',
        },
      );


      List<dynamic> rawList = response.data;
      return rawList.map((json) => CatalogItem.fromJson(json)).toList();
    } catch (e) {
      print("Erreur API catalogue: $e");
      return [];
    }
  }
}
