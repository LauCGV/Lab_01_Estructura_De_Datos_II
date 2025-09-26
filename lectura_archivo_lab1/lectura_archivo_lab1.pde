import java.util.function.Function; //<>// //<>// //<>//
import controlP5.*;
import java.util.ArrayList;
import java.util.Arrays;
ControlP5 cp5, tfl;
int cont = 0;

BufferedReader reader;
String line;
String[][] data = new String[1000][100];
double[] temperature = new double[65];
double sum;

ArbolAVL arbol = new ArbolAVL(null);
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

Nodo nodoP = null;
int cantidad_nodos = 0;
Nodo nodoSeleccionado = null;
Vista vista;

PImage fondo1, fondoMenu, panelRecorrido;
float minX, maxX, maxY;
int currentX = 0;
Nodo x;
Textfield tf_insertar, tf_eliminar, tf_buscarProm, tf_buscarAño1, tf_buscarAño2, tf_buscarValor, tl_obtenerISO, recorrido, tl_nISO, tl_nPAIS;

Boolean dibujarArbolInsertar = false;
String texto = "Sin recorrido";

Nodo n, nodo;

void setup() {
  frameRate(60);
  size(1080, 720);

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
    if (dibujarArbolInsertar) {
      //Calcular posiciones iniciales
      currentX = 0;
      x.calcularPosiciones(arbol.root, 0);
      minX = Float.MAX_VALUE;
      maxX = Float.MIN_VALUE;
      maxY = 0;
      x.calcularLimites(arbol.root);
      x.escalarPosiciones(arbol.root, minX, maxX, maxY);
      x.dibujar(arbol.root);
    }
    if (vista.panelNiveles == true) {
      vista.mostrarPanelRecorrido();
      vista.ocultarTextFieldsMenu(true);
    }
  }
}

void mousePressed() {
  if (vista.pantalla1==true && mouseX >= width*0.395 && mouseX <= width*0.395 + width*0.208 && mouseY >= height*0.629 && mouseY <= height*0.629 + height*0.138) {
    vista.pantalla1 = false;
    vista.pantalla2 = true;
  }
  if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.175 + height * 0.0462) {

    insertar_nodo(tf_insertar.getText().trim());
    tf_insertar.setText("");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.175 && mouseY <= height * 0.231 + height * 0.0462) {

    eliminar_nodo(tf_eliminar.getText().trim());

    tf_eliminar.setText("");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.453 && mouseY <= height * 0.453 + height * 0.0462) {
    println("");
    println("BUSCAR POR PROMEDIO");
    try {
      Nodo nodo_temp = arbol.search(arbol.root, Double.parseDouble(tf_buscarProm.getText().trim()));
      if (nodo_temp != null) {
        println("  Id: "+nodo_temp.id + " - country: "+nodo_temp.country+" - ISO3: "+nodo_temp.ISO3+" - promedio de temperatura: "+nodo_temp.prom_temp);
      } else {
        println("  No existe un nodo con ese promedio.");
      }
    }
    catch(NumberFormatException e) {
      println("  Debe ingresar un valor numerico");
    }
    tf_buscarProm.setText("");
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.537 && mouseY <= height * 0.537 + height * 0.0462) {

    boolean ver1 = size_year(tf_buscarAño1.getText());
    if (ver1) {
      ArrayList<Nodo> lista1 = new ArrayList<>();
      lista1 = nodos_temp_year(parseInt(tf_buscarAño1.getText()));
      println("");
      println("LISTA DE PAISES CRITERIO 1");
      
      for (Nodo x : lista1) {
        println(" " + x.ISO3);
      }
      cont = 1;
    } else {
      println("  Ingrese un año valido.");
    }
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.620 && mouseY <= height * 0.620 + height * 0.0462) {

    boolean ver2 = size_year(tf_buscarAño2.getText());
    if (ver2) {
      ArrayList<Nodo> lista2 = new ArrayList<>();
      lista2 = nodos_temp_years(parseInt(tf_buscarAño2.getText()));
      println("");
      println("LISTA DE PAISES CRITERIO 2");
      
      for (Nodo x : lista2) {
        println(" " + x.ISO3);
      }
      cont = 2;
    } else {
      println(" Ingrese un año valido.");
    }
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.712 && mouseY <= height * 0.712 + height * 0.0462) {

    ArrayList<Nodo> lista3 = new ArrayList<>();
    lista3 = nodos_temp_prom(parseInt(tf_buscarValor.getText()));
    println("");
    println("LISTA DE PAISES CRITERIO 3");
    
    for (Nodo x : lista3) {
      println(" " + x.ISO3);
    }
    cont = 3;
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.8518 && mouseY <= height * 0.8518 + height * 0.0462) {

    if (cont == 1) {
      nodoP= promedio_busquedas(nodos_lower_prom, tl_obtenerISO.getText().trim());
    } else if (cont == 2) {
      nodoP= promedio_busquedas(nodos_above_prom, tl_obtenerISO.getText().trim());
    } else if (cont == 3) {
      nodoP = promedio_busquedas(nodos_greater_value, tl_obtenerISO.getText().trim());
    } else if (cont == 0) {
      println("No se ha realizado ninguna busqueda");
    }
    if (nodoP != null) {
      println("DATOS DEL NODO " + nodoP.ISO3);
      Nodo pa = obtener_pad(nodoP.prom_temp);

      if (pa != null) {
        println( "  - Padre: "+pa.ISO3);
        Nodo abu = obtener_pad(pa.prom_temp);
        if (abu != null) {
          println( "  - Abuelo: "+ abu.ISO3);
          Nodo tio = arbol.tio(abu, pa);
          if (tio != null) {
            println( "  - Tío: "+ tio.ISO3);
          } else {
            println("  - El tio es nulo");
          }
        } else {
          println("  - El abuelo es nulo");
          println("  - El tío es nulo");
        }
      } else {
        println("  - El padre es nulo.");
        println("  - El abuelo es nulo.");
        println("  - El tío es nulo");
      }

      int FE = arbol.factor_balanceo(nodoP);
      println( "  - Factor de equilibrio: "+ FE);

      int nivel = arbol.obtenerNivel(arbol.root, nodoP.prom_temp);
      println( "  - Nivel del nodo: "+ nivel);
    } else {
      print("  No se ingreso un ISO valido");
    }
    tl_obtenerISO.setText("");
    
  } else if (mouseX >=  width * 0.281 && mouseX <= width * 0.281 + width * 0.026 && mouseY >= height * 0.324 && mouseY <= height * 0.324 + height * 0.0462) {

    String pais = tl_nPAIS.getText().trim();
    String iso  = tl_nISO.getText().trim();
    
    if (pais == null || pais.trim().isEmpty() ||
      iso == null || iso.trim().isEmpty()) {
      println(" Uno de los campos está vacío o solo tiene espacios.");
    } else {
      if (iso.trim().matches("[A-Za-z]{3}")) {
        insertar_nodo_nuevo(pais, iso);
      } else {
        println(" El ISO3 debe tener exactamente 3 letras pegadas");
      }
    }
    tl_nPAIS.setText("");
    tl_nISO.setText("");
  } else if (mouseX >=  0 && mouseX <= width * 0.322 && mouseY >= height * 0.916 && mouseY <= height * 0.916 + height * 0.074) {
    println("");
    println("RECORRIDO POR NIVELES");
    String x = recorrido_por_niveles();
    x = x.substring(1);
    println(x);
  }
}


// ================ FUNCIONES DE LOS BOTONES ================

boolean size_year(String year_s) {
  try {
    double year = Double.parseDouble(year_s);
    if (year >= 1961 && year <= 2022) {
      return true;
    }
    return false;
  }
  catch(NumberFormatException e) {
    return false;
  }
}

Nodo promedio_busquedas(ArrayList<Nodo> nodos_pruebas, String iso_busqueda) {
  for (Nodo n : nodos_pruebas) {
    if (n.ISO3.equals(iso_busqueda)) {
      return n;
    }
  }
  return null;
}



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
  arbol.root = arbol.insert(arbol.root, nodo); // importante reasignar la raíz

  //Calcular posiciones iniciales
  currentX = 0;
  x.calcularPosiciones(arbol.root, 0);
  minX = Float.MAX_VALUE;
  maxX = Float.MIN_VALUE;
  maxY = 0;
  x.calcularLimites(arbol.root);
  x.escalarPosiciones(arbol.root, minX, maxX, maxY);
  return;
}


// INSERTAR NODO NUEVO
boolean insertar_nodo_nuevo(String count, String iso) {

  Nodo result_count = arbol.search_atribute(arbol.root, count, n -> n.country);
  if (result_count != null) {
    ;
    return false;
  }
  Nodo result_iso = arbol.search_atribute(arbol.root, count, n -> n.ISO3);
  if (result_iso != null) {
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
    prom_temp = (float) acum_temp/cant_nodos(arbol.root);
    resultado_prom = arbol.search(arbol.root, prom_temp);
  } while (resultado_prom != null);
  Nodo nodo_nuevo = new Nodo(new_id, count, iso, prom_temp, temp);

  dibujarArbolInsertar = true;
  arbol.root = arbol.insert(arbol.root, nodo_nuevo); // importante reasignar la raíz

  //Calcular posiciones iniciales
  currentX = 0;
  x.calcularPosiciones(arbol.root, 0);
  minX = Float.MAX_VALUE;
  maxX = Float.MIN_VALUE;
  maxY = 0;
  x.calcularLimites(arbol.root);
  x.escalarPosiciones(arbol.root, minX, maxX, maxY);
  println("Inserción del nuevo nodo realizada con exito.");
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
  int indice = year-1961;
  promedio_year(arbol.root, indice);
  cant_nodos(arbol.root);
  arbol.search_above_prom_year(arbol.root, indice, cant_nodos(arbol.root));
  return nodos_lower_prom;
}

//BUSCAR NODOS CON TEMPERATURA EN UN AÑO MENOR AL PROMEDIO DE LOS PROMEDIOS
ArrayList<Nodo> nodos_temp_years(int year) {
  nodos_above_prom.clear();
  acum_temp_years = 0;
  int indice = year -1961;
  promedio_years(arbol.root);
  cant_nodos(arbol.root);
  arbol.search_lower_prom_years(arbol.root, indice, cant_nodos(arbol.root));
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
  arbol.root = arbol.eliminar(Double.parseDouble(country));
}

// RECORRIDO POR NIVELES
String recorrido_por_niveles() {
  arbol.recorridoPorNiveles();
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
