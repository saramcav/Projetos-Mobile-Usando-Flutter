class Tarefa {
  int? id;
  String? titulo;
  String? descricao;
  String? data;
  int realizada = 0;

  Tarefa(this.titulo, this.descricao, this.data);

  Tarefa.fromMap(Map map) {
    id = map["id"];
    titulo = map["titulo"];
    descricao = map["descricao"];
    data = map["data"];
    realizada = map["realizada"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "titulo": titulo,
      "descricao": descricao,
      "data": data,
      "realizada": realizada
    };

    map["id"] ??= id;

    return map;
  }  
}