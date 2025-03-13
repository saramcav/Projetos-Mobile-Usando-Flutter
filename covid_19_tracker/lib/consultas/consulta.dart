import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Consulta extends StatelessWidget {
  final String _url;
  //titulo que fica no appbar
  final String _titulo;
  //variavel que indica se a consulta é agrupada ou nao 
  //se for individual exibe um card pra cada dado do estado ou pais selecionado
  //senao, agrupa por {estado, pais, data & estado}, exibindo um card pra cada grupo e seus dados dentro de cada card
  final bool individual;

  const Consulta(this._url, this.individual,this._titulo,{super.key});

  Future<Map> _buscaMapa() async {
    http.Response response;
    response = await http.get(Uri.parse(_url));
    return jsonDecode(response.body); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: Text(
          _titulo, 
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: FutureBuilder<Map> (
          future: _buscaMapa(),
          builder:(context, snapshot) {
            Map? mapa;
            if (snapshot.hasData) {
              mapa = snapshot.data!;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            //ou retorna-se um card pra cada dado(como "uf", "cases", etc) do estado selecionado
            //ou retorna-se um card pra cada dado(como "country", "cases", etc) do pais selecionado
            //o index percorre esses dados
            if(individual) {
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                //lidando com os tipos de json diferentes retornados pela API
                itemCount: mapa.containsKey("data")? mapa["data"].keys.length : mapa.keys.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blueGrey.shade600,
                    shadowColor: Colors.white,
                    elevation: 5,
                    child: SizedBox(
                      width: 365,
                      height: 100,
                      child: Center(
                        child: ListTile(
                          //lidando com os tipos de json diferentes retornados pela API
                          title: mapa!.containsKey("data")? 
                            Text("${mapa["data"].keys.elementAt(index)}", style: const TextStyle(fontWeight: FontWeight.bold),) : 
                            Text("${mapa.keys.elementAt(index)}", style: const TextStyle(fontWeight: FontWeight.bold),), 
                          subtitle: mapa.containsKey("data")? 
                            Text("${mapa["data"][mapa["data"].keys.elementAt(index)]}") : 
                            Text("${mapa[mapa.keys.elementAt(index)]}"),
                          leading: const CircleAvatar(backgroundImage: AssetImage('imagens/coronavirus.png')),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              //retorna-se um card para cada {estado, pais, data agrupada por estado}
              //o indice grupo percorre {os estados, os paises, a data agrupada por estado}
              //o indice valor percorre as chaves e valores de cada {estado, pais, data agrupada por estado}, 
              //(como "uf", "cases", etc) e retorna um listlite para dentro do "card pai"
              return ListView.separated(
                separatorBuilder: (BuildContext context, int grupo) => const Divider(),
                itemCount: mapa["data"].length,
                itemBuilder: (context, grupo) {
                  return Card(
                    color: Colors.blueGrey.shade600,
                    shadowColor: Colors.white,
                    elevation: 5,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int valor) => const Divider(),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: mapa!["data"][grupo].keys.length,
                      itemBuilder: (context, valor) {
                        return ListTile(
                          title: Text("${mapa!["data"]![grupo].keys.elementAt(valor)}", style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle:  Text("${mapa["data"][grupo][mapa["data"][grupo].keys.elementAt(valor)]}"),
                          leading: const CircleAvatar(backgroundImage:  AssetImage('imagens/coronavirus.png')),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}