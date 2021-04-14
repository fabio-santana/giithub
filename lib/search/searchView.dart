import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../search/search.dart';

class SearchView extends GetView<SearchController> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List user = [];
    // SearchDados cliente;
    // var cpfcnpj = GetStorage().read('cpfcnpj');

    var bottomBar = Text(
      'Feito por Fabio S. Santana',
    );
    var appBar = AppBar(title: Text('GiitHub User Search'));
    final alturaAppBar = appBar.preferredSize.height;
    final alturaDisponivel = context.height - alturaAppBar;

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Obx(() {
                      return Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontSize: 15.0),
                                  controller: controller.userLov.value,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Informe aqui os dados da consulta',
                                    labelStyle: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  user = await controller.getUsers(controller.userLov.value.text);
                                  // user = controller.listaAtualizada(x);
                                },
                                icon: Icon(Icons.search),
                                label: Text('Pesquisar'),
                              ),
                              (controller.apiBusy.value == true)
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SingleChildScrollView(
                                      child: Container(
                                        height: alturaDisponivel * 0.80,
                                        // height: 950.0,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: user.length,
                                            itemBuilder: (context, i) {
                                              print('REGISTROS: ' + user.length.toString());
                                              return Padding(
                                                padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 0),
                                                child: Card(
                                                  child: ListTile(
                                                    onTap: () {
                                                      // if (_formKey.currentState.validate()) {
                                                      //   cliente = user[i];

                                                      //   // Get.toNamed(Routes.PRODUTOS, arguments: [cpfcnpj, cliente]);
                                                      // } else {
                                                      //   Get.snackbar(
                                                      //     'Atenção',
                                                      //     'CPF/CNPJ informado é inválido. Verifique!',
                                                      //     icon: Icon(Icons.report),
                                                      //     shouldIconPulse: true,
                                                      //     barBlur: 50,
                                                      //     isDismissible: false,
                                                      //     margin: EdgeInsets.all(8),
                                                      //     backgroundColor: Colors.red[300],
                                                      //     colorText: Colors.white,
                                                      //     duration: Duration(seconds: 2),
                                                      //     snackPosition: SnackPosition.BOTTOM,
                                                      //   );
                                                      // }
                                                    },
                                                    // leading:
                                                    leading: CircleAvatar(
                                                      backgroundImage: NetworkImage(user[i].avatarUrl),
                                                    ),
                                                    title: Text(
                                                      user[i].login,
                                                      style: TextStyle(fontSize: 15.0),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    trailing: Icon(Icons.star),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: bottomBar,
      ),
    );
  }
}
