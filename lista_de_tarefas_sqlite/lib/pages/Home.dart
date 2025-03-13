import 'package:flutter/material.dart';
import 'package:notas_app/helper/TarefaHelper.dart';
import 'package:notas_app/model/Tarefa.dart';
import "package:intl/intl.dart";
import "package:intl/date_symbol_data_local.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  var _db = TarefaHelper();
  List<Tarefa> tarefas = [];

  //exibe um calendario interativo para que a pessoa coloque a data limite da tarefa
  Future<void> _buscaData(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme:
                    const ColorScheme.light(primary: Colors.lightGreen),
              ),
              child: child!);
        });
    if (dataSelecionada != null && dataSelecionada != DateTime.now()) {
      setState(() {
        dataController.text = dataSelecionada.toString();
      });
    }
  }

  //cria e insere com o atributo realizada = falso(0), caso nao seja passada tarefa no parametro 
  //atualiza o titulo, a descricao e a data da tarefa passada no parametro
  void _insertUpdateTarefa({Tarefa? selectedTarefa}) async {
    String titulo = tituloController.text;
    String descricao = descricaoController.text;
    String data = dataController.text;

    if (selectedTarefa == null) {
      Tarefa tarefa = Tarefa(titulo, descricao, data);

      int result = await _db.insertTarefa(tarefa);
      
    } else {
      //nesse momento, os controllers ja contem com os dados antigos
      //entao caso algum valor seja igual ao que ja existia nao havera perda
      selectedTarefa.titulo = titulo;
      selectedTarefa.descricao = descricao;
      selectedTarefa.data = data;

      int result = await _db.updateTarefa(selectedTarefa);
    }

    tituloController.clear();
    descricaoController.clear();
    dataController.clear();

    _getTarefas();
  }

  //essa funcao mudara apenas o atributo "realizada" da tarefa
  void _insertUpdateTarefa2({Tarefa? selectedTarefa, int? realizada}) async {
    int result = await _db.updateTarefa2(selectedTarefa!, realizada!);

    _getTarefas();
  }

  void _getTarefas() async {
    List results = await _db.getTarefas();
    print("Lista: ${results.toString()}");
    tarefas.clear();

    for (var item in results) {
      Tarefa tarefa = Tarefa.fromMap(item);
      tarefas.add(tarefa);
    }

    setState(() {});
  }

  _removeTarefa(int? id) async {
    await _db.deleteTarefa(id!);

    _getTarefas();
  }

  //formata a data salva para deixa-la visualizavel no subtitulo e na caixa de edicao
  _formatData(String data) {
    initializeDateFormatting("pt_BR", "");

    var formatter = DateFormat.yMMMMd("pt_BR");

    DateTime newDate = DateTime.parse(data);
    return formatter.format(newDate);
  }

  //ira chamar a funcao que cria uma nova tarefa com o atributo realizada = falso(0) caso nao haja tarefa passada como parametro
  //ira chamar a funcao que atualizar os atributos titulo, descricao e data caso seja passada uma tarefa como parametro
  _showRegisterScreen({Tarefa? tarefa}) async {
    String saveUpdateText = "";
    String tituloAnterior = "";

    if (tarefa == null) {
      tituloController.text = "";
      descricaoController.text = "";
      //cria com a data atual caso nao a alterem
      dataController.text = DateTime.now().toString();
      saveUpdateText = "Crie sua tarefa!";
    } else {
      //setando os controllers para os dados antigos, que poderao ser editados conjunta e separadamente
      tituloAnterior = tarefa.titulo!;
      tituloController.text = tituloAnterior;
      descricaoController.text = tarefa.descricao!;
      dataController.text = tarefa.data!;
      saveUpdateText = "Edite sua tarefa!";
    }

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(saveUpdateText),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            //recebendo os dados da tarefa a ser criada ou atualizada
            children: [
              TextField(
                controller: tituloController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Título", hintText: "Digite o título"),
              ),
              TextField(
                controller: descricaoController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Descrição", hintText: "Digite a descrição"),
              ),
              TextField(
                controller: dataController,
                autofocus: true,
                decoration: InputDecoration(
                  //caso seja uma nova tarefa, exibira a data atual, caso seja antiga, exibira a data salva no bd
                  labelText: "Data salva: ${_formatData(dataController.text)}",
                ),
                //exibe um calendario para que coloquem a data ate a qual a tarefa precisa ser realizada
                onTap: () async => _buscaData(context)
              ),
              const SizedBox(height: 7,),
              const  Text(
                "Clique acima para selecionar uma data", 
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                //insere no database -> se tarefa!=null, ela será atualizada; senao sera criada. tudo isso dentro da funcao abaixo
                _insertUpdateTarefa(selectedTarefa: tarefa);
                //no caso de atualizacao, sera exibida uma exibe mensagem de confirmacao de edicao
                if (tarefa != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$tituloAnterior editada com sucesso"),
                    duration: const Duration(seconds: 3),
                  ));
                }
                Navigator.pop(context);
              },
              child: const Text("Salvar")
            ),
          ],
        );
      }
    );
  }

  //ira chamar a funcao que exclui a tarefa arrastada e exibir uma mensagem
  _confirmaExclusao(Tarefa tarefa) async {
    String removida = tarefa.titulo!;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirme a ação!"),
          content: Text("Tem certeza de que deseja excluir $removida da sua lista de tarefas?"),
          actions: <Widget> [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                //Exclui do Database e exibe mensagem de confirmacao de remocao
                _removeTarefa(tarefa.id!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$removida  removida com sucesso"),
                  duration: const Duration(seconds: 2),
                ));
                Navigator.of(context).pop(true);
              },
              child: const Text("Sim")
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  thickness: 2,
                ),
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final item = tarefas[index];
                  return Dismissible(
                    key: ValueKey(item.id.toString()),
                    direction: DismissDirection.horizontal,
                    //para direita, exibe-se um alert dialog no qual a pessoa insere as novas informacoes da tarefa
                    //para esquerda, exibe-se um alert dialog em que a pessoa escolher se realmente deseja excluir ou nao
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.endToStart) {
                        _confirmaExclusao(item);
                      } else {
                        _showRegisterScreen(tarefa: item);
                      }
                    },
                    //ao arrastar para direita, sera exibido um fundo amarelo com icone de edicao
                    background: Container(
                      color: Colors.yellow,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          )
                        ]
                      ),
                    ),
                    //ao arrastar para esquerda, sera exibido um fundo vermelho com icone de exclusao
                    secondaryBackground: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          )
                        ]
                      ),
                    ),
                    //lista e checa se a caixa foi marcada 
                    //se sim, chama a funcao que atualiza apenas o atributo "realizada" da tarefa
                    child: CheckboxListTile(
                      title: Text(
                        item.titulo!,
                        style: const TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 17
                        ),
                      ),
                      subtitle: Text( "${_formatData(item.data!.toString())} - ${item.descricao!}"),
                      activeColor: Colors.lightGreen,
                      //faz o parse ja que "realizada" esta guardado como int no banco de dados
                      value: item.realizada == 0 ? false : true,
                      //quando a caixa e clicada, atualiza-se o atributo realizada daquele item
                      //desfaz-se o parse para passar o parametro ja que "realizada" esta guardado como int no banco de dados
                      onChanged: (newVal) {
                        _insertUpdateTarefa2(selectedTarefa: item, realizada: newVal! ? 1 : 0);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => _showRegisterScreen(),
      ),
    );
  }
}
