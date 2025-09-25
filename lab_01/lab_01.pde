import java.util.ArrayList; //<>// //<>//
import java.util.Arrays;
import java.util.function.Function;
BufferedReader reader;
String line;
String[][] data = new String[1000][100];
double[] temperature = new double[65];
double sum;
ArbolAVL arbol = new ArbolAVL();
ArrayList<Nodo> nodos = new ArrayList<Nodo>();
ArrayList<Nodo> pasos = new ArrayList<Nodo>();
ArrayList<ArrayList<String>> datos = new ArrayList<ArrayList<String>>();
int pasoActual = 0;
String count_id = "226";

double acum_temp_year = 0;
double acum_temp_years = 0;
int cantidad_nodos = 0;
ArrayList<Nodo> nodos_lower_prom = new ArrayList<Nodo>();
ArrayList<Nodo> nodos_above_prom = new ArrayList<Nodo>();
ArrayList<Nodo> nodos_greater_value = new ArrayList<Nodo>();
String recorrido_niveles = "";




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
      ArrayList<String> pais = new ArrayList<String>();

      //OBTENCIÓN DE LOS ATRIBUTOS
      String objectID, country, iso3, prom;
      double sum = 0;
      objectID = data_line.get(0).trim();

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
      prom = String.valueOf(sum / 62);

      pais.add(objectID);
      pais.add(country);
      pais.add(iso3);
      pais.add(prom);
      for (double temp : temp_country) {
        pais.add(String.valueOf(temp));
      }
      datos.add(pais);
    }
  }
}
void draw() {
}

// ================ FUNCIONES DE LOS BOTONES ================

// INSERTAR NODO POR ISO3
void insertar_nodo(String country) {
  for (ArrayList<String> pais : datos) {
    if (pais.get(2).equalsIgnoreCase(country)) {
      ArrayList<Double> temp = new ArrayList<Double>();
      for (int i = 4; i<=65; i++) {
        temp.add(Double.parseDouble(pais.get(i)));
      }
      Nodo nodo = new Nodo(pais.get(0), pais.get(1), pais.get(2), Double.parseDouble(pais.get(3)), temp);
      arbol.insert(nodo);
      return;
    }
  }
}


// INSERTAR NODO NUEVO
boolean insertar_nodo_nuevo(String count, String iso) {
  Nodo result_count = arbol.search_atribute(arbol.root, count, n -> n.country);
  if (result_count == null) {
    return false;
  }
  Nodo result_iso = arbol.search_atribute(arbol.root, count, n -> n.ISO3);
  if (result_iso == null) {
    return false;
  }
  String new_id = count_id;
  count_id = String.valueOf(Integer.parseInt(count_id+1));
  ArrayList <Double> temp = new ArrayList<Double> ();
  double acum_temp = 0;
  double min = -2.07;
  double max = 3.7;
  Nodo resultado_prom;
  double prom_temp;
  do {
    for (int i = 0; i < 62; i++) {
      double randomValue = min + Math.random() * (max - min);
      temp.add(randomValue);
      acum_temp += randomValue;
    }
    prom_temp = (float) acum_temp/cantidad_nodos;
    resultado_prom = arbol.search(arbol.root, prom_temp);
  } while (resultado_prom == null);
  Nodo nodo_nuevo = new Nodo(new_id, count, iso, prom_temp, temp);
  arbol.insert(nodo_nuevo);
  return true;
}

// BUSCAR POR ID
Nodo buscar_ID(String id) {
  Nodo busqueda_id = arbol.search_atribute(arbol.root, id, n -> n.id);
  return busqueda_id;
}

// BUSCAR POR PAIS
Nodo buscar_country(String count) {
  Nodo busqueda_count = arbol.search_atribute(arbol.root, count, n -> n.country);
  return busqueda_count;
}

// BUSCAR POR ISO
Nodo buscar_iso(String iso) {
  Nodo busqueda_iso = arbol.search_atribute(arbol.root, iso, n -> n.ISO3);
  return busqueda_iso;
}

//BUSCAR NODOS CON TEMPERATURA EN UN AÑO MAYOR AL PROMEDIO DE ESE AÑO
ArrayList<Nodo> nodos_temp_year(int year) {
  nodos_lower_prom.clear();
  acum_temp_year = 0;
  cantidad_nodos = 0;
  int indice = year-1961;
  promedio_year(arbol.root, indice);
  cant_nodos(arbol.root);
  arbol.search_above_prom_year(arbol.root, indice);
  return nodos_lower_prom;
}

//BUSCAR NODOS CON TEMPERATURA EN UN AÑO MENOR AL PROMEDIO DE LOS PROMEDIOS
ArrayList<Nodo> nodos_temp_years(int year) {
  nodos_above_prom.clear();
  acum_temp_years = 0;
  cantidad_nodos = 0;
  int indice = year -1961;
  promedio_years(arbol.root);
  cant_nodos(arbol.root);
  arbol.search_lower_prom_years(arbol.root, indice);
  return nodos_above_prom;
}

// BUSCAR NODOS CON PROMEDIO MAYOR A UN VALOR
ArrayList<Nodo> nodos_temp_prom(double value) {
  nodos_greater_value.clear();
  arbol.search_greater_value(arbol.root, value);
  return nodos_greater_value;
}

// ELIMINAR NODO POR ISO3
void eliminar_nodo(String country) {
  Nodo nodo_eliminar = arbol.search_atribute(arbol.root, country, n -> n.ISO3);
  arbol.eliminar(nodo_eliminar.prom_temp);
}

// RECORRIDO POR NIVELES
String recorrido_por_niveles(){
  arbol.recorridoPorNiveles();
  return recorrido_niveles;
}

// OBTENER EL PADRE DE UN NODO
Nodo obtener_pad(double promedio){
  ArrayList<Nodo> temp= new ArrayList<Nodo>();
  temp = arbol.search_iterative(arbol.root, promedio);
  return temp.get(1);
}



// ================ UTILIDADES GLOBALES =====================
void promedio_year(Nodo nodo, int index) {
  if (nodo != null) {
    promedio_year(nodo.left, index);
    acum_temp_year += nodo.temperatures.get(index);
    promedio_year(nodo.right, index);
  }
}

void promedio_years(Nodo nodo) {
  if (nodo != null) {
    promedio_years(nodo.left);
    acum_temp_years += nodo.prom_temp;
    promedio_years(nodo.right);
  }
}

int cant_nodos(Nodo nodo) {
  if (nodo == null) {
    return 0;
  } else {
    return 1 + cant_nodos(nodo.left) + cant_nodos(nodo.right);
  }
}
