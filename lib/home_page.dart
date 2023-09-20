import 'dart:js_interop';

import 'package:consumer_api_viacep/cep_model.dart';
import 'package:consumer_api_viacep/cep_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CepRepository cepRepository = CepRepository();
  var ceps = [];

  TextEditingController cepController = TextEditingController();

  @override
  void initState() {
    getCeps();
    super.initState();
  }

  void getCeps() async {
    ceps = await cepRepository.getListCeps();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CEPS"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          CepModel cepMostrar = CepModel();

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                height: 300,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Cep",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: cepController,
                        decoration: const InputDecoration(
                          hintText: "Digite o Cep",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    cepMostrar.isNull
                        ? Container()
                        : SizedBox(
                            height: 60,
                            child: Column(
                              children: [
                                Text(cepMostrar.logradouro ?? ""),
                                Text(cepMostrar.localidade ?? ""),
                                Text(cepMostrar.bairro ?? ""),
                                Text(cepMostrar.complemento ?? ""),
                                Text(cepMostrar.uf ?? "")
                              ],
                            ),
                          ),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            cepMostrar =
                                await cepRepository.getCep(cepController.text);
                          },
                          child: const Text("Mostrar"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!cepMostrar.isNull) {
                              await cepRepository.saveCepBack4app(cepMostrar);
                              const ScaffoldMessenger(
                                child: SnackBar(
                                  content: Text("Cep salvo"),
                                ),
                              );
                            } else {
                              const ScaffoldMessenger(
                                child: SnackBar(
                                  content: Text("Cep não salvo"),
                                ),
                              );
                            }
                          },
                          child: const Text("Salvar"),
                        ),
                      ],
                    )
                    // TODO: Colocar Um botão de mostrar e outro de Salvar
                    // TODO: O Botão de mostrar vai mostrar as infos do cep digitado e atualizara uma variavel para que mostre umc ontainer vaZio ou as infos do cep
                  ],
                ),
              );
            },
          );
        },
        label: const Text("Adicionar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: ceps.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            ceps[index]["cep"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const Divider(),
                          Text(ceps[index]["logradouro"]),
                          Text(ceps[index]["complemento"]),
                          Text(ceps[index]["bairro"]),
                          Text(ceps[index]["localidade"]),
                          Text(ceps[index]["uf"]),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
