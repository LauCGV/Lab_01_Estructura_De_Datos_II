class Nodo {
  int id;
  String country;
  String ISO3;
  double prom_temp;
  ArrayList<Double> temperatures;
  Nodo left, right, pad;
  int altura;

  public Nodo(int id, String country, String ISO3, double prom_temp, ArrayList<Double> temperatures) {
    this.id = id;
    this.country = country;
    this.ISO3 = ISO3;
    this.temperatures = temperatures;
    this.prom_temp = prom_temp;
    this.left = null;
    this.right = null;
    this.pad = null;
    this.altura = 1;
  }
}
