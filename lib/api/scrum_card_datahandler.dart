import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scrumboard/api/scrum_card_datahandler_local.dart';
import 'package:scrumboard/model/login.dart';
import 'package:scrumboard/model/scrum_card.dart';

class ScrumCardDataHandler {
  final baseTokenUrl = 'https://10.0.2.2:27016/api/Authentication';
  final baseScrumCardUrl = 'https://10.0.2.2:27016/api/ScrumCard';
  HttpClient httpClient = HttpClient();

  Future<List<ScrumCard>> getScrumCardCollection() async {

    var storage = const FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    if (token == null) {
      throw Exception('[ERROR] No token in secure storage');
    }

    var headers = {"Authorization": "Bearer $token"};
    httpClient = await setHttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse(baseScrumCardUrl))
          ..headers.contentType =
              ContentType('application', 'json', charset: 'utf-8')
          ..headers.add(headers.keys.first, headers.values.first);

    var response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
          '[ERROR] Failed to post - response code: ${response.statusCode}');
    }

    var responseBody = await response.transform(utf8.decoder).join();

    List<ScrumCard> tempCollection = [];

    for (var item in json.decode(responseBody)) {
      ScrumCard card = ScrumCard.fromJson(item);
      tempCollection.add(card);
    }

    return tempCollection;
  }

  Future<String> postLogin(Login login) async {
    httpClient = await setHttpClient();
    var request = await httpClient.postUrl(Uri.parse('$baseTokenUrl/login'))
      ..headers.add('Content-Type', 'application/json')
      ..add(
        utf8.encode(
          json.encode(
            login.toMap(),
          ),
        ),
      );
    var response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
          '[ERROR] Failed to login - response code: ${response.statusCode}');
    }

    var responseBody = await response.transform(utf8.decoder).join();

    String token = jsonDecode(responseBody)["token"];

    var storage = const FlutterSecureStorage();
    await storage.deleteAll();
    await storage.write(key: "token", value: token);

    return token;
  }

  Future<ScrumCard> postScrumCard(ScrumCard card) async {
    var storage = const FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    if (token == null) {
      throw Exception('[ERROR] No token in secure storage');
    }

    var headers = {"Authorization": "Bearer $token"};
    httpClient = await setHttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(baseScrumCardUrl))
          ..headers.contentType =
              ContentType('application', 'json', charset: 'utf-8')
          ..headers.add(headers.keys.first, headers.values.first)
          ..add(
            utf8.encode(
              json.encode(
                card.toMap(),
              ),
            ),
          );

    var response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
          '[ERROR] Failed to login - response code: ${response.statusCode}');
    }

    var responseBody = await response.transform(utf8.decoder).join();

    ScrumCard scrumCard = ScrumCard.fromJson(json.decode(responseBody));

    final local = ScrumCardLocalDataHandler();

    await local.upsertScrumCardLocal(scrumCard);

    return ScrumCard.fromJson(json.decode(responseBody));
  }

  Future<ScrumCard> putScrumCard(ScrumCard card) async {
    var storage = const FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    String id = card.id!;

    if (token == null) {
      throw Exception('[ERROR] No token in secure storage');
    }

    var headers = {"Authorization": "Bearer $token"};
    httpClient = await setHttpClient();
    HttpClientRequest request = await httpClient.putUrl(
      Uri.parse('$baseScrumCardUrl/$id'),
    )
      ..headers.contentType =
          ContentType('application', 'json', charset: 'utf-8')
      ..headers.add(headers.keys.first, headers.values.first)
      ..add(
        utf8.encode(
          json.encode(
            card.toMap(),
          ),
        ),
      );

    var response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
          '[ERROR] Failed to login - response code: ${response.statusCode}');
    }

    var responseBody = await response.transform(utf8.decoder).join();

    ScrumCard scrumCard = ScrumCard.fromJson(json.decode(responseBody));

    final local = ScrumCardLocalDataHandler();

    await local.upsertScrumCardLocal(scrumCard);

    return scrumCard;
  }

  Future<void> deleteScrumCard(ScrumCard card) async {
    var storage = const FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    String id = card.id!;

    if (token == null) {
      throw Exception('[ERROR] No token in secure storage');
    }

    var headers = {"Authorization": "Bearer $token"};
    httpClient = await setHttpClient();
    HttpClientRequest request =
        await httpClient.deleteUrl(Uri.parse('$baseScrumCardUrl/$id'))
          ..headers.contentType =
              ContentType('application', 'json', charset: 'utf-8')
          ..headers.add(headers.keys.first, headers.values.first);

    var response = await request.close();

    if (response.statusCode != 204) {
      throw Exception(
          '[ERROR] Failed to delete - response code: ${response.statusCode}');
    }
  }

  Future<HttpClient> setHttpClient() async {
    ByteData trustedCertificate =
        await rootBundle.load('assets/127.0.0.1+2-client.p12');
    ByteData certificateChain =
        await rootBundle.load('assets/127.0.0.1+2-client.pem');
    ByteData privateKey =
        await rootBundle.load('assets/127.0.0.1+2-client-key.pem');
    List<int> trustedCertificateBytes = trustedCertificate.buffer.asUint8List(
        trustedCertificate.offsetInBytes, trustedCertificate.lengthInBytes);
    List<int> certificateChainBytes = certificateChain.buffer.asUint8List(
        certificateChain.offsetInBytes, certificateChain.lengthInBytes);
    List<int> privateKeyBytes = privateKey.buffer
        .asUint8List(privateKey.offsetInBytes, privateKey.lengthInBytes);
    SecurityContext context = SecurityContext();
    context.setTrustedCertificatesBytes(trustedCertificateBytes,
        password: 'changeit');
    context.useCertificateChainBytes(certificateChainBytes,
        password: 'changeit');
    context.usePrivateKeyBytes(privateKeyBytes, password: 'changeit');
    return HttpClient(context: context);
    // ..badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
  }
}
