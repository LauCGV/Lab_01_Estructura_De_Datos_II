import java.util.function.Function; //<>// //<>//
import controlP5.*;
import java.util.ArrayList; //<>//
import java.util.Arrays;
ControlP5 cp5, tfl;

BufferedReader reader;
String line;
String[][] data = new String[1000][100];
double[] temperature = new double[65];
double sum;

ArbolAVL arbol = new ArbolAVL(null);
ArbolAVL arbolInsertar = new ArbolAVL(null);
ArrayList<Nodo> nodos = new ArrayList<Nodo>();
ArrayList<Nodo> pasos = new ArrayList<Nodo>();
ArrayList<ArrayList<String>> datos = new ArrayList<ArrayList<String>>();
int pasoActual = 0;
String count_id = "226";

double acum_temp_year = 0;
double acum_temp_years = 0;
ArrayList<Nodo> nodos_lower_prom = new ArrayList<Nodo>();
ArrayList<Nodo> nodos_above_prom = new ArrayList<Nodo>();
ArrayList<Nodo> nodos_greater_value = new ArrayList<Nodo>();
String recorrido_niveles = "";

int cantidad_nodos = 0;
Nodo nodoSeleccionado = null;
Vista vista;

PImage fondo1, fondoMenu, panelRecorrido;
float minX, maxX, maxY;
int currentX = 0;
Nodo x;
Textfield tf_insertar, tf_eliminar, tf_buscarISO, tf_buscarAño1, tf_buscarAño2, tf_buscarValor, tl_obtenerISO, recorrido;

Boolean dibujarArbolInsertar = false;
String texto = "Sin recorrido";

Nodo n, nodo;

void setup() {
  frameRate(60);
  fullScreen();

  cp5 = new ControlP5(this);
  currentX = 0;
  textAlign(CENTER, CENTER);
  textSize(16);
  vista = new Vista();
  fondo1 = loadImage("fondo1.png");
  fondoMenu = loadImage("pantalla2.png");
  panelRecorrido = loadImage("MostrarRecorrido.png");
  x = new Nodo();
  vista.mostrarTextfieldsPantalla2();


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

  /*// Mostrar países cargados
   for (Nodo nodo : nodos) {
   println("ObjectID:" + nodo.id + " country:" + nodo.country + " iso:" + nodo.ISO3 + " promedio:" + nodo.prom_temp);
   }*/

  //above_average_temp_year(1967);
  //below_average_tempe_years(1980);
}


ArrayList<Nodo> above_average_temp_year(int year) {

  ArrayList<Nodo> temp = new ArrayList<Nodo>();
  int index = year-1961;
  double acum = 0, promYear = 0;
  for (Nodo node : nodos) {
    acum = node.temperatures.get(index)+acum;
  }
  promYear = acum/nodos.size();
  for (Nodo node : nodos) {
    if (node.temperatures.get(index) > promYear) {
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
  for (Nodo node : nodos) {
    acum = node.prom_temp+acum;
  }
  promYears = acum/nodos.size();
  for ( Nodo node : nodos) {
    if (node.temperatures.get(index) < promYears) {
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
  if (vista.pantalla1 == true) {
    vista.ocultarTextFieldsMenu(true);
    vista.mostrarPantallaPrincipal();
  } else if (vista.pantalla2 == true) {
    vista.mostrarMenuPrincipal();
    vista.ocultarTextFieldsMenu(false);
    if(dibujarArbolInsertar){
      x.dibujar(arbolInsertar.root);
    }
    if(vista.panelNiveles == true){
      vista.mostrarPanelRecorrido();
      vista.ocultarTextFieldsMenu(true);
    }
  } else if (vista.pantalla3 == true) {
    background(255);
    fill(0);
    //text("Paso: " + pasoActual, 80, 30);
    if (pasoActual < pasos.size()) {
      Nodo n = pasos.get(pasoActual); // sacar el nodo
      arbol.root = arbol.insert(arbol.root, n); // importante reasignar la raíz
      pasoActual++;
      //Calcular posiciones iniciales
      currentX = 0;
      x.calcularPosiciones(arbol.root, 0);
      minX = Float.MAX_VALUE;
      maxX = Float.MIN_VALUE;
      maxY = 0;
      x.calcularLimites(arbol.root);
      x.escalarPosiciones(arbol.root, minX, maxX, maxY);
      
    }

    x.dibujar(arbol.root);
  }
}

void mousePressed() {
  if (vista.pantalla1==true && mouseX >= width*0.395 && mouseX <= width*0.395 + width*0.208 && mouseY >= height*0.629 && mouseY <= height*0.629 + height*0.138) {
    vista.pantalla1 = false;
    vista.pantalla2 = true;
    println("HOLA");
  }
  if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.175 + height * 0.0462) {
    println("Insertar");
    insertar_nodo(tf_insertar.getText().trim());
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.231 + height * 0.0462) {
    println("Eliminar");
    eliminar_nodo(tf_eliminar.getText().trim());
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.453 + height * 0.0462) {
    println("ISO");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.537 + height * 0.0462) {
    println("Año");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.620 + height * 0.0462) {
    println("Año2");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.712 + height * 0.0462) {
    println("Valor");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.8518 + height * 0.0462) {
    println("Obtener");
  }
  
  if (mouseX >=  0 && mouseX <= width * 0.312 && mouseY >= height * 0.916 && mouseY <= height * 0.916 + height * 0.083) {
    texto = recorrido_por_niveles();
    vista.panelNiveles = true;
    println("MostrarRecorrido");   
  }
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
      nodo = new Nodo(pais.get(0), pais.get(1), pais.get(2), Double.parseDouble(pais.get(3)), temp);
    }
  }
  
  dibujarArbolInsertar = true;
  arbolInsertar.root = arbolInsertar.insert(arbolInsertar.root, nodo); // importante reasignar la raíz
  
  //Calcular posiciones iniciales
  currentX = 0;
  x.calcularPosiciones(arbolInsertar.root, 0);
  minX = Float.MAX_VALUE;
  maxX = Float.MIN_VALUE;
  maxY = 0;
  println("2");
  x.calcularLimites(arbolInsertar.root);
  x.escalarPosiciones(arbolInsertar.root, minX, maxX, maxY);
  return;
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
  println("A");
  arbolInsertar.eliminar(Double.parseDouble(country));
  //Nodo nodo_eliminar = arbol.search_atribute(arbol.root, country, n -> n.ISO3);
  //arbolInsertar.eliminar(nodo_eliminar.prom_temp);
  println("X");
  
}

// RECORRIDO POR NIVELES
String recorrido_por_niveles() {
  arbolInsertar.recorridoPorNiveles();
  return recorrido_niveles;
}

// OBTENER EL PADRE DE UN NODO
Nodo obtener_pad(double promedio) {
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
