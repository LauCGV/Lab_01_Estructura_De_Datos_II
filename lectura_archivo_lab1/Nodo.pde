class Nodo {
  String id;
  String country;
  String ISO3;
  double prom_temp;
  ArrayList<Double> temperatures;
  Nodo left, right, father;
  int altura;
  float x, y; // coordenadas para dibujar
  float posicionX = width*0.328;   // esquina superior izquierda
  float posicionY = height * 0.018;
  float ancho = width * 0.656;   // ancho disponible
  float alto = height * 0.962;   // alto disponible

  float nodoSize = 40;


  public Nodo() {
  }
  public Nodo(String id, String country, String ISO3, double prom_temp, ArrayList<Double> temperatures) {
    this.id = id;
    this.country = country;
    this.ISO3 = ISO3;
    this.temperatures = temperatures;
    this.prom_temp = prom_temp;
    this.left = null;
    this.right = null;
    this.altura = 1;
    this.father = null;
  }

  // Paso 1: calcular posiciones (in-order traversal)
  void calcularPosiciones(Nodo nodo, int depth) {
    if (nodo == null) return;

    calcularPosiciones(nodo.left, depth+1);


    nodo.x = currentX * 80;  // separación horizontal base
    nodo.y = depth * 100;    // separación vertical
    currentX++;

    calcularPosiciones(nodo.right, depth+1);
  }

  // Paso 2: encontrar límites y escalar
  void escalarPosiciones(Nodo nodo, float minX, float maxX, float maxY) {
    if (nodo == null) return;

    // calcular escalas para que todo quepa en pantalla
    float escalaX = (ancho - 100) / (maxX - minX + 1);
    float escalaY = (alto - 100) / (maxY + 1);

    aplicarEscala(nodo, minX, escalaX, escalaY, posicionX, posicionY);
  }

  void aplicarEscala(Nodo nodo, float minX, float escalaX, float escalaY, float offsetX, float offsetY) {

    if (nodo == null) return;
    nodo.x = (nodo.x - minX) * escalaX + offsetX + 25;
    nodo.y = nodo.y * escalaY + offsetY + 25;
    aplicarEscala(nodo.left, minX, escalaX, escalaY, offsetX, offsetY);
    aplicarEscala(nodo.right, minX, escalaX, escalaY, offsetX, offsetY);
  }
  
  

  // Paso 3: dibujar
  void dibujar(Nodo nodo) {
    if (nodo == null) return;

    // aristas
    stroke(255);
    if (nodo.left != null) line(nodo.x, nodo.y, nodo.left.x, nodo.left.y);
    if (nodo.right != null) line(nodo.x, nodo.y, nodo.right.x, nodo.right.y);

    // nodo
    fill(200, 220, 255);
    ellipse(nodo.x, nodo.y, nodoSize, nodoSize);

    fill(0);
    textAlign(CENTER, CENTER);
    text(nodo.ISO3, nodo.x, nodo.y);
    // Factor de equilibrio
    int fe = arbol.factor_balanceo(nodo);
    fill(fe == 0 ? color(0, 150, 0) : color(200, 0, 0));
    text("FE: " + fe, nodo.x, nodo.y + 25);

    dibujar(nodo.left);
    dibujar(nodo.right);
  }

  void calcularLimites(Nodo nodo) {
    if (nodo == null) return;
    minX = min(minX, nodo.x);
    maxX = max(maxX, nodo.x);
    maxY = max(maxY, nodo.y);
    calcularLimites(nodo.left);
    calcularLimites(nodo.right);
  }
}
