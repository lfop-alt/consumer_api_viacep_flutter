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
  List<CepModel> ceps = <CepModel>[];

  bool isLoading = true;
  bool isLoadingShow = false;

  TextEditingController cepController = TextEditingController();

  @override
  void initState() {
    getCeps();
    super.initState();
  }

  void getCeps() async {
    ceps = await cepRepository.getListCeps();
    setState(() {
      isLoading = false;
    });
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  height: 400,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Cep",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: cepController,
                          decoration: const InputDecoration(
                            hintText: "Digite o Cep",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      isLoadingShow
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              height: 160,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(cepMostrar.logradouro ?? ""),
                                    Text(cepMostrar.localidade ?? ""),
                                    Text(cepMostrar.bairro ?? ""),
                                    Text(cepMostrar.uf ?? "")
                                  ],
                                ),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: cepController.text.length < 8
                                ? null
                                : () async {
                                    setState(() {
                                      isLoadingShow = true;
                                    });
                                    cepMostrar = await cepRepository
                                        .getCep(cepController.text);

                                    setState(() {
                                      isLoadingShow = false;
                                    });
                                  },
                            child: const Text("Mostrar"),
                          ),
                          ElevatedButton(
                            onPressed: cepController.text.length < 8
                                ? null
                                : () async {
                                    if (cepMostrar != null) {
                                      await cepRepository
                                          .saveCepBack4app(cepMostrar);
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
                                      getCeps();
                                      Navigator.pop(context);
                                    }
                                  },
                            child: const Text("Salvar"),
                          ),
                        ],
                      )
                    ],
                  ),
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
          return isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Dismissible(
                      onDismissed: (_) {
                        cepRepository.deleteCepBack4app(ceps[index].objectId!);
                      },
                      key: Key(ceps[index].objectId ?? index.toString()),
                      child: SizedBox(
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
                                    ceps[index].cep!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Divider(),
                                  Text(ceps[index].logradouro!),
                                  Text(ceps[index].complemento!),
                                  Text(ceps[index].bairro!),
                                  Text(ceps[index].localidade!),
                                  Text(ceps[index].uf!),
                                ],
                              ),
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
