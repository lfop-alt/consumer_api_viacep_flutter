import 'package:consumer_api_viacep/cep_model.dart';
import 'package:dio/dio.dart';

class CepRepository {
  final _dio = Dio();

  Future<List<CepModel>> getListCeps() async {
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    _dio.options.headers["X-Parse-Application-Id"] =
        "rpZR1FnMwqpl2ys6uN9aNYgkr0TaB8fo7q2fTxew";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "EVaXixmaXKopSvUvfvtdvRQgBXnThC4lOkUiZIii";
    var response = await _dio.get("/Ceps");

    return (response.data["results"] as List)
        .map((e) => CepModel.fromJson(e))
        .toList();
  }

  Future<CepModel> getCep(String cep) async {
    var response = await _dio.get("https://viacep.com.br/ws/$cep/json/");

    return CepModel.fromJson(response.data);
  }

  Future<void> saveCepBack4app(CepModel data) async {
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    _dio.options.headers["X-Parse-Application-Id"] =
        "rpZR1FnMwqpl2ys6uN9aNYgkr0TaB8fo7q2fTxew";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "EVaXixmaXKopSvUvfvtdvRQgBXnThC4lOkUiZIii";
    _dio.options.headers["Content-Type"] = "application/json";
    await _dio.post("/Ceps", data: data);
  }

  Future<void> deleteCepBack4app(String objectId) async {
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    _dio.options.headers["X-Parse-Application-Id"] =
        "rpZR1FnMwqpl2ys6uN9aNYgkr0TaB8fo7q2fTxew";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "EVaXixmaXKopSvUvfvtdvRQgBXnThC4lOkUiZIii";

    await _dio.delete(
      "/Ceps/$objectId",
    );
  }
}
