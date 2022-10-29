import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContratLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545";
  final String _privateKey =
      "c01178763e1cf3c66d6527e1d36c9640434de0d43399baded9af4113db213e9e";

  Web3Client? _web3client;
  bool isLoading = true;

  String? _abiCode;
  EthereumAddress? _contractAddress;
  Credentials? _credentials;
  DeployedContract? _contract;

  ContractFunction? _uris;
  ContractFunction? _createTokenURI;
  List<String>? uris;

  String? address;

  ContratLinking() {
    setUp();
  }

  setUp() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbiForNFT();
    await getCredentials();
    await getDeployedContractForNFT();
  }

  Future<void> getAbiForNFT() async {
    String abiStringFile =
        await rootBundle.loadString('build/contracts/CreateNFT.json');

    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContractForNFT() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "CreateNFT"), _contractAddress!);

    _uris = _contract!.function('getAllTokenURIs');
    _createTokenURI = _contract!.function('createTokenURI');
    getURIs();
  }

  getURIs() async {
    final _myuris = await _web3client!
        .call(contract: _contract!, function: _uris!, params: []);

    uris = (_myuris[0] as List<dynamic>).map((e) => e.toString()).toList();
    address = _contractAddress.toString();

    isLoading = false;
    notifyListeners();
  }

  CreateTokenURI(String uri) async {
    isLoading = true;
    notifyListeners();
    await _web3client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
          contract: _contract!, function: _createTokenURI!, parameters: [uri]),
    );
    getURIs();
  }
}
