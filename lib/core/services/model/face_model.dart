
class FaceModel {
  final int? id;
  final String name;
  final List<double> embedding;
  final String imagePaths;

  FaceModel({
    this.id,
    required this.name,
    required this.embedding,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'embedding': embedding.join(','),
      'imagePaths': imagePaths
    };
  }

  factory FaceModel.fromMap(Map<String, dynamic> map) {
    return FaceModel(
      id: map['id'],
      name: map['name'],
      embedding: map['embedding']
          .split(',')
          .map<double>((e) => double.parse(e))
          .toList(),
      imagePaths: map['imagePaths']
    );
  }
}
