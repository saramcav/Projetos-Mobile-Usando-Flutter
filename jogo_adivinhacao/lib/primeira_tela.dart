import 'dart:math';
import 'package:adivinhacao2/segunda_tela.dart';
import 'package:flutter/material.dart';

//Nesta classe, é setado o valor sorteado aleatoriamente e definido o número de tentativas 
class PrimeiraTela extends StatefulWidget {
  const PrimeiraTela({super.key});

  @override
  State<PrimeiraTela> createState() =>  _EstadoPrimeiraTela();
}

class _EstadoPrimeiraTela extends State<PrimeiraTela> {
  int? _numeroSecreto;
  Object? _numeroTentativas;

  void _geraSecreto() {
    setState(() {
      Random numeroAleatorio = Random();
      _numeroSecreto = numeroAleatorio.nextInt(100);
    });
    //print('Número sorteado: $_numeroSecreto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Jogo de Adivinhação", 
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 65.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            
            //Neste Container, estou sobrepondo imagens e textos para deixar a tela inicial mais bonitinha
            Container(
              height: 270,
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://i0.wp.com/www.skooterblog.com/wp-content/uploads/2009/04/akinator_1_defi1.png', //akinator
                  ),  
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: const [
                  Positioned(
                    left: 15.0,
                    bottom: 220.0,
                    child:   Text(
                      "   Selecione \na dificuldade!",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Image(
                      image: NetworkImage(
                        'https://cdn.pixabay.com/photo/2012/04/11/17/51/balloon-29142_960_720.png', //balão de texto
                        scale: 7,
                      ),  
                    ),
                  ),
                ],
              ),
            ),

            //Definindo o número de tentativas por meio da lista de dificuldades
            RadioListTile(
              value: 20,
              groupValue: _numeroTentativas,
              onChanged: (value) {
                setState(() {
                  _numeroTentativas = value;
                });
              },
              toggleable: true,
              title: const Text("Fácil"),
              subtitle: const Text("Você tem 20 tentativas!"),
            ),
            RadioListTile(
              value: 15,
              groupValue: _numeroTentativas,
              onChanged: (value) {
                setState(() {
                  _numeroTentativas = value;
                });
              },
              toggleable: true,
              title: const Text("Médio"),
              subtitle: const Text("Você tem 15 tentativas!"),
            ),
            RadioListTile(
              value: 6,
              groupValue: _numeroTentativas,
              onChanged: (value) {
                setState(() {
                  _numeroTentativas = value;
                });
              },
              toggleable: true,
              title: const Text("Difícil"),
              subtitle: const Text("Você tem 6 tentativas!"),
            ),

            const SizedBox(height: 7),

            //Ao clicar nest botão, se o número de tentativas já estiver setado, o número secreto é sorteado
            //Depois a rota vai à segunda tela, com os parâmetros: número secreto e número de tentativas
            ElevatedButton(
              onPressed:() {
                if(_numeroTentativas != null){
                  _geraSecreto();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SegundaTela(_numeroSecreto, _numeroTentativas))
                  );
                }
              },
              child: const Text(
                "Iniciar",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
