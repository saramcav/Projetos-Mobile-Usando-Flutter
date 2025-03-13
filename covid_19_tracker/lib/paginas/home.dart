import 'package:app_covid/paginas/analise_individual.dart';
import 'package:app_covid/paginas/pagina_brasil.dart';
import 'package:flutter/material.dart';
import 'package:app_covid/consultas/consulta.dart';

//Essa e a pagina inicial. Nela ha os cards "brasil", "todos os paises" e "consultar por pais"
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        centerTitle: true,
        title: const Text(
          "Covid-19 Tracker", 
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
            //ao clicar no botao "brasil", redireciona-se a pagina que contem as filtragens nacionais
            GestureDetector(
              onTap:() => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const PaginaBrasil()),
              ),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Brasil", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para filtrar informações nacionais"),
                      leading: CircleAvatar(backgroundImage: AssetImage('imagens/busca.png')),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //ao clicar no botao "todos os paises", mostra-se as informacoes da requisicao get agrupadas por pais
            GestureDetector(
              onTap:() => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const Consulta("https://covid19-brazil-api.now.sh/api/report/v1/countries", false, "Análise internacional")),
              ),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Todos os países", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para analisar todos os países"),
                      leading: CircleAvatar(backgroundImage: AssetImage('imagens/busca.png')),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //ao clicar no botao "consultar por pais", redireciona-se a pagina que contem uma lista de botoes com os paises possiveis
            GestureDetector(
              onTap:() => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Analise("https://covid19-brazil-api.vercel.app/api/report/v1/countries", "por pais")),
              ),
              child: Card(
                color: Colors.blueGrey.shade600,
                shadowColor: Colors.white,
                elevation: 5,
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: ListTile(
                      title: Text("Consultar por país", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle:  Text("Clique aqui para selecionar o país desejado"),
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