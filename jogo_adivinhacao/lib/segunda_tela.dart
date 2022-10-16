import 'package:flutter/material.dart';

//Nesta classe, o jogador faz o chute, é definido o resultado e exibido na tela
class SegundaTela extends StatefulWidget {
  final int? _numeroSecreto;
  final Object? _numeroTentativas;

  //Construtor para pegar parâmetros da primeira tela 
  const SegundaTela(this._numeroSecreto, this._numeroTentativas, {super.key});

  @override
  State<SegundaTela> createState() =>  _EstadoSegundaTela();
}

class _EstadoSegundaTela extends State<SegundaTela> {
  double _pontos = 1000.0;
  final TextEditingController _controller = TextEditingController();
  bool? _ganhou;
  //quantChutes é a quantidade de tentativas que o jogador tentou na atual partida
  int _quantChutes = 0;
   //Mensagem mostra a dica, caso o jogador não tenha acertado, 
   //a parabenização e a pontuação, caso ele tenha ganhado, 
   //e a mensagem de tentar novamente, caso tenha excedido as tentativas
  String _mensagem = "";
  


  void _defineResultado(int numeroChutado) {
    if(numeroChutado != widget._numeroSecreto){
      _decrementaPontos(numeroChutado);

      if(_quantChutes == widget._numeroTentativas) {
        _ganhou = false;
        _mensagem = "Você perdeu! Tente novamente!";
      } else {
        if (numeroChutado > widget._numeroSecreto!) {
          _mensagem = "Dica: O número secreto é menor";
         } else {
          _mensagem = "Dica: O número secreto é maior";
        }
      }
    } else {
      _ganhou = true;
      _mensagem = "Parabéns, você adivinhou!\nPontuação total: $_pontos";
    }
  }

  void _decrementaPontos(int numeroChutado) {
    //int num = widget._numeroSecreto as int;
    _pontos -= (numeroChutado - widget._numeroSecreto!).abs()/2.0;
  }

  //Exibe uma tela contendo a tentativa, o chute e a mensagem durante 5 segundos
  void _mostraSnackBar(int chute){
    final snackBar = SnackBar(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: NetworkImage(
                'https://3.bp.blogspot.com/-jDsBEPSQ7cQ/TqjNfLIsrfI/AAAAAAAAGgE/soK9dqLU6QQ/s1600/lampadadogenio.GIF',
              ),  
            ),
            const SizedBox(height: 40),
            Text(
              "Tentativa: $_quantChutes/${widget._numeroTentativas}\n\nChute: $chute\n\n$_mensagem",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor:Colors.lightBlue.shade50,
    );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: const Text(
          "Tente a Sorte!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: NetworkImage(
                'http://2.bp.blogspot.com/_Vp0VFBj-QV8/SwiKwkHhwxI/AAAAAAAAAWs/kKF6Tp0jqto/s1600/Akinator+-+Blog+do+Nel.jpg',
                scale: 1.6,
              ),
            ),

            //Ao submeter o número, a quantidade de chutes é incrementada,
            //É checado se o jogador acertou
            //É exibida a tela com os dados do chute
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              onSubmitted: (controller) {
                _quantChutes++;
                int num = int.parse(_controller.text);
                _defineResultado(num);
                _mostraSnackBar(num);
                //Se o jogador ganhou ou perdeu, volta à primeira tela
                if(_ganhou != null){
                  Navigator.pop(context);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu chute",
              ),
            ),
          ],
        ),
      ),
    );
  }
}