import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:provider/provider.dart';

import 'contrat_linking.dart';

class NFTPage extends StatelessWidget {
  const NFTPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contratLink = Provider.of<ContratLinking>(context);
    final _messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Create dApp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: contratLink.isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                    child: Column(
                children: <Widget>[
                  Text('Welcome to the NFT Create dApp'),
                  20.heightBox,
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter URI/Text for NFT',
                    ),
                    controller: _messageController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      contratLink.CreateTokenURI(_messageController.text);
                      _messageController.clear();
                    },
                    child: const Text('Create NFT'),
                  ),
                  20.heightBox,
                  "All NFTs".text.bold.sky600.xl2.make().objectCenterLeft(),
                  ...contratLink.uris!
                      .map((uri) => AStack(children: [
                            uri.text.make(),
                          ]))
                      .toList()
                ],
              ))),
      ),
    );
  }
}
