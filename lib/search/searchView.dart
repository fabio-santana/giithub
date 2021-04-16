import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search/search.dart';
import '../widgets/widgets.dart';
import '../user/user.dart';

class SearchView extends GetView<SearchController> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GlobalKey _formKey = GlobalKey<FormState>();
    List user = [];
    // RxBool favorite = false.obs;

    UserController userController = Get.put(UserController());
    // SearchDados cliente;

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
                      user = controller.listaUsers.toList();

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
                                  if (controller.userLov.value.text == null || controller.userLov.value.text == '') {
                                    Get.snackbar(
                                      'Atenção',
                                      'Não existe valor informado para pesquisa. Verifique.',
                                      icon: Icon(Icons.report_problem),
                                      shouldIconPulse: true,
                                      barBlur: 50,
                                      isDismissible: false,
                                      margin: EdgeInsets.all(8),
                                      backgroundColor: Colors.blue, // redAccent,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 5),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    user = await controller.getUsers(controller.userLov.value.text);
                                  }
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
                                              return Padding(
                                                padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 0),
                                                child: Card(
                                                  child: ListTile(
                                                    onTap: () async {
                                                      var detail = await userController.getUser(user[i].url);

                                                      print('URL DO USUÁRIO: ' + user[i].url);
                                                      Get.defaultDialog(
                                                          radius: 6.0,
                                                          title: 'Dados adicionais',
                                                          actions: [
                                                            Form(
                                                              key: _formKey,
                                                              child: DryIntrinsicHeight(
                                                                child: Container(
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundImage: NetworkImage(user[i].avatarUrl),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Localização: ',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            detail.location ?? '',
                                                                            style: TextStyle(fontSize: 15.0),
                                                                            // overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Bio: ',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child: Text(
                                                                              detail.bio ?? '',
                                                                              style: TextStyle(fontSize: 15.0),
                                                                              maxLines: 5,

                                                                              // overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Nome: ',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            detail.name ?? '',
                                                                            style: TextStyle(fontSize: 15.0),
                                                                            // overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'E-mail: ',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            detail.email ?? '',
                                                                            style: TextStyle(fontSize: 15.0),
                                                                            // overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          cancel: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                side: BorderSide(color: Colors.blue),
                                                              ),
                                                              primary: Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'Fechar',
                                                              style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          middleText: '${detail.login}');
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

                                                    // trailing: IconButton(
                                                    //   icon: user[i].isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
                                                    //   onPressed: () {
                                                    //     // user[i].isFavorite = !favorite.value;
                                                    //     print(user[i].isFavorite.toString());
                                                    //     controller.makeFavorite(i, !user[i].isFavorite);
                                                    //   },
                                                    // ),
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
