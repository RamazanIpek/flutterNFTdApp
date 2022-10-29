import 'package:flutter/material.dart';
import 'package:nft_create_dapp/nft_page.dart';
import 'package:provider/provider.dart';

import 'contrat_linking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContratLinking>(
      create: (context) => ContratLinking(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NFT create dApp',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const NFTPage(),
      ),
    );
  }
}
