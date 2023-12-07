class Avaliacao {
  late final int id;
  late final int idUsuario;
  late final String avatar;
  late final String usuario;
  late final double rating;
  late final String comentario;
  late final String data;

  Avaliacao(this.id, this.idUsuario, this.avatar, this.usuario, this.rating,
      this.comentario, this.data);

  // Construtor factory para criar uma instância de Avaliacao a partir de JSON
  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      json['id'] as int,
      json['id_usuario'] as int,
      json['avatar'] as String,
      json['usuario'] as String,
      double.parse(json['rating']),
      json['comentario'] as String,
      json['data'] as String,
    );
  }
}
