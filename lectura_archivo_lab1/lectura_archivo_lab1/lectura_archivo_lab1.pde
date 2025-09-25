import java.util.ArrayList; //<>// //<>// //<>//
import java.util.Arrays;
BufferedReader reader;
String line;
String[][] data = new String[1000][100];
double[] temperature = new double[65];
double sum;
ArbolAVL arbol = new ArbolAVL();
ArrayList<Nodo> nodos = new ArrayList<Nodo>();
ArrayList<Nodo> pasos = new ArrayList<Nodo>();
int pasoActual = 0;
Nodo nodoSeleccionado = null;

void setup() {
  size(1000, 600);
  textAlign(CENTER, CENTER);
  textSize(16);
  frameRate(1); // 1 paso por segundo

  // === LECTURA DEL DATASET ===
  reader = createReader("dataset_climate_change.csv");
  try {
    reader.readLine(); // saltar cabecera
  }
  catch (IOException e) {
    e.printStackTrace();
  }

  while (true) {
    try {
      line = reader.readLine();
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }

    if (line == null) {
      break;
    } else {
      String[] pieces = split(line, ',');
      ArrayList<String> data_line = new ArrayList<String>(Arrays.asList(pieces));
      ArrayList<Double> temp_country = new ArrayList<Double>();

      // Crear atributos
      int objectID;
      String country, iso3;
      double sum = 0, prom;
      objectID = Integer.parseInt(data_line.get(0).trim());

      if (data_line.get(1).contains("\"")) {
        country = data_line.get(1).trim() + ", " + data_line.get(2).trim();
        data_line.remove(2);
      } else {
        country = data_line.get(1).trim();
      }
      iso3 = data_line.get(2).trim();

      for (int i = 3; i <= 64; i++) {
        sum += Double.parseDouble(data_line.get(i).trim());
        temp_country.add(Double.parseDouble(data_line.get(i).trim()));
      }
      prom = sum / 62;

      // Crear nodo con los datos del país
      Nodo node = new Nodo(objectID, country, iso3, prom, temp_country);
      nodos.add(node);
      pasos.add(node);

      // Aquí decides qué usar para "pasos" en el árbol AVL
      //pasos.add(objectID); // ejemplo usando el id como clave
      // pasos.add((int)prom); // si prefieres insertar por promedio de temperatura
    }
  }

  // Mostrar países cargados
  for (Nodo nodo : nodos) {
    println("ObjectID:" + nodo.id + " country:" + nodo.country + " iso:" + nodo.ISO3 + " promedio:" + nodo.prom_temp);
  }

  above_average_temp_year(1967);
  below_average_tempe_years(1980);
}


ArrayList<Nodo> above_average_temp_year(int year) {

  ArrayList<Nodo> temp = new ArrayList<Nodo>();
  int index = year-1961;
  double acum = 0, promYear = 0;
  for (Nodo node : nodos){
    acum = node.temperatures.get(index)+acum;
  }
  promYear = acum/nodos.size();
  for (Nodo node : nodos){
    if(node.temperatures.get(index) > promYear){
      temp.add(node);
     // println("Pais: "+node.id);
    }
  }
  return temp;
}

ArrayList<Nodo> below_average_tempe_years(int year) {
  ArrayList<Nodo> temp = new ArrayList<Nodo>();
  int index = year-1961;
  double acum = 0, promYears = 0;
  for (Nodo node : nodos){
    acum = node.prom_temp+acum;
  }
  promYears = acum/nodos.size();
  for ( Nodo node : nodos){
    if(node.temperatures.get(index) < promYears){
      temp.add(node);
      println("Pais: "+node.id);
    }
  }
  return temp;
}

void keyPressed() {
  if (key == 'd' && nodoSeleccionado != null) {
    double val = nodoSeleccionado.prom_temp;
    arbol.eliminar(val);
    println("Eliminado: " + val);
    nodoSeleccionado = null; // limpiar selección
  }
}

void draw() {
  background(255);
  fill(0);
  text("Paso: " + pasoActual, 80, 30);

  if (pasoActual < pasos.size()) {
    Nodo n = pasos.get(pasoActual); // sacar el nodo
    arbol.root = arbol.insert(arbol.root, n); // importante reasignar la raíz
    pasoActual++;
}


  dibujarArbol(arbol.root, width/2, 60, width/4);
}

void dibujarArbol(Nodo nodo, float x, float y, float offset) {
  if (nodo == null) return;

  // Líneas
  stroke(0);
  if (nodo.left != null)
    line(x, y, x - offset, y + 60);
  if (nodo.right != null)
    line(x, y, x + offset, y + 60);

  boolean seleccionado = (nodoSeleccionado == nodo);

  // Nodo (resaltado si seleccionado)
  fill(seleccionado ? color(255, 200, 150) : color(200, 220, 255));
  ellipse(x, y, 40, 40);
  fill(0);
  text(nodo.ISO3, x, y);

  // Factor de equilibrio
  int fe = arbol.factor_balanceo(nodo);
  fill(fe == 0 ? color(0, 150, 0) : color(200, 0, 0));
  text("FE: " + fe, x, y + 25);

  // Verificar clic sobre este nodo
  if (mousePressed) {
    float distMouse = dist(mouseX, mouseY, x, y);
    if (distMouse < 20) { // radio del círculo
      nodoSeleccionado = nodo;
    }
  }

  // Recursión
  dibujarArbol(nodo.left, x - offset, y + 60, offset/1.5);
  dibujarArbol(nodo.right, x + offset, y + 60, offset/1.5);
}
