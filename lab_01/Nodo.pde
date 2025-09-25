class Nodo {
  String id;
  String country;
  String ISO3;
  double prom_temp;
  ArrayList<Double> temperatures;
  Nodo left, right;
  int altura;

  public Nodo(String id, String country, String ISO3, double prom_temp, ArrayList<Double> temperatures) {
    this.id = id;
    this.country = country;
    this.ISO3 = ISO3;
    this.temperatures = temperatures;
    this.prom_temp = prom_temp;
    this.left = null;
    this.right = null;
    this.altura = 1;
  }
}
