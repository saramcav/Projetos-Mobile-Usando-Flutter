import 'dart:async';
import 'package:app_covid/paginas/analise_individual.dart';
import 'package:app_covid/consultas/consulta.dart';
import 'package:flutter/material.dart';

//essa pagina contem informacoes de filtragem nacional
class PaginaBrasil extends StatelessWidget {
  const PaginaBrasil({super.key});

  //seleciona a data e mostra as informacoes da requisicao get agrupadas por estado
  Future<void> _buscaData(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
    if (dataSelecionada != null && dataSelecionada != DateTime.now()) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => Consulta("https://covid19-brazil-api.now.sh/api/report/v1/brazil/${dataSelecionada.toString().substring(0, 10).replaceAll("-", "")}", false, dataSelecionada.toString().substring(0, 10).split('-').reversed.join('/'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: const Text(
          "Análise nacional", 
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('imagens/covid_fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[ 
           const SizedBox(height: 10,),
           //ao clicar no botao "geral", mostra-se as informacoes da requisicao get agrupadas por estado
            GestureDetector(
              onTap:() => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const Consulta("https://covid19-brazil-api.now.sh/api/report/v1", false, "Análise geral nacional")),
              ),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Geral", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para analisar todos os estados"),
                      leading: CircleAvatar(backgroundImage: AssetImage('imagens/busca.png')),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //ao clicar no botao "por estado", redireciona-se a pagina que contem uma lista de botoes com os estados possiveis
            GestureDetector(
              onTap:() => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const Analise("https://covid19-brazil-api.now.sh/api/report/v1", "por estado")),
              ),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Por estado", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para buscar um estado"),
                      leading: CircleAvatar(backgroundImage: AssetImage('imagens/busca.png')),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //ao clicar no botao "por data", mostra-se um calendario para que se escolha a data a ser analisada
            GestureDetector(
              onTap: (() async {
                _buscaData(context);
              }),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Por data", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para filtrar uma data"),
                      leading: CircleAvatar(backgroundImage: AssetImage('imagens/busca.png')),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}