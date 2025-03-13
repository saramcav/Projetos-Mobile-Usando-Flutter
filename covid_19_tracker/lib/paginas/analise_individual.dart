import 'package:flutter/material.dart';
import 'package:app_covid/consultas/consulta.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

//essa pagina contem uma lista de botoes com os estados ou paises possiveis e redireciona para a pagina de consulta
class Analise extends StatelessWidget {
  final String _url;
  final String analise;
  
  const Analise(this._url, this.analise, {super.key});

  Future<List<dynamic>> retornaLista() async{
    http.Response response;
    response = await http.get(Uri.parse(_url));
    return jsonDecode(response.body)["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: (analise == "por estado")?
         const Text(
          "Selecione a UF", 
          style: TextStyle(
            color: Colors.white,
          ),
        ) :
        const Text(
          "Selecione o país", 
          style: TextStyle(
            color: Colors.white,
          )
        ),
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: FutureBuilder<List<dynamic>> (
          future: retornaLista(),
          builder:(context, snapshot) {
            List<dynamic>? lista;
            if (snapshot.hasData) {
              lista = snapshot.data!;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            //o listview percorre todos os estados ou paises existentes na url e cria um botao para cada um deles 
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                //ao clicar em um estado ou pais, mostra-se as informacoes da requisicao get dado a dado em cards
                return ElevatedButton (
                  onPressed: (() {
                    if (analise == "por estado") {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Consulta("https://covid19-brazil-api.now.sh/api/report/v1/brazil/uf/${lista![index]["uf"]}", true,"${lista[index]["state"]}")),
                      );
                    } else{
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Consulta("https://covid19-brazil-api.vercel.app/api/report/v1/${lista![index]["country"].toString().toLowerCase()}", true, "${lista[index]["country"]}")),
                      );
                    }       
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade600,
                    shadowColor: Colors.white,
                    elevation: 5,
                  ), 
                  child: (analise == "por estado")?
                    Text(lista![index]["uf"].toString().toUpperCase()):
                    Text(lista![index]["country"])
                );
              },
            );
          },
        ),
      ),
    );
  }
}