class ArbolAVL {
  Nodo root;

  public ArbolAVL(Nodo root) {
    this.root = null;
  }
  // ================== BÚSQUEDA ==================
  Nodo search(Nodo root, double valor) {
    //valor = Math.round(valor * 1e9) / 1e9; //Formateo decimales
    if (root == null) return null;
    if (Math.abs(valor - root.prom_temp) < 1e-6) return root;
    if (valor < root.prom_temp) return search(root.left, valor);
    else return search(root.right, valor);
  }
  // ============ BÚSQUEDA ============
  ArrayList<Nodo> search_iterative(Nodo root, double element) {
    ArrayList<Nodo> temp = new ArrayList<Nodo>();
    Nodo p = root;
    Nodo pad = null;
    while (p != null) {
      if (p.prom_temp == element) {
        temp.add(p);
        temp.add(pad);
        return temp;
      } else {
        pad = p;
        if (element < p.prom_temp) {
          p=p.left;
        } else {
          p=p.right;
        }
      }
    }
    temp.add(null);
    temp.add(pad);
    return temp;
  }

  

  Nodo search_atribute(Nodo root, String value, Function<Nodo, String> atributo) {
    if (root == null) {
      return null;
    }
    if (atributo.apply(root).equalsIgnoreCase(value)) {
      return root;
    }
    Nodo leftResult = search_atribute(root.left, value, atributo);
    if (leftResult != null) {
      return leftResult;
    }
    return search_atribute(root.right, value, atributo);
  }
  // ============ BÚSQUEDA DE NODOS POR ===========
  //  TEMPERATURA EN UN AÑO MAYOR AL PROMEDIO DE ESE AÑO

  // ============ BÚSQUEDA DE NODOS POR ===========
  //  TEMPERATURA EN UN AÑO MAYOR AL PROMEDIO DE ESE AÑO

  void search_above_prom_year(Nodo nodo, int index, int cant_nodos) {
    if (nodo != null) {
      search_above_prom_year(nodo.left, index, cant_nodos);
      if ((float)acum_temp_year/cant_nodos < nodo.temperatures.get(index)) {
        nodos_lower_prom.add(nodo);
      }
      search_above_prom_year(nodo.right, index, cant_nodos);
    }
  }

  //  TEMPERATURA EN UN AÑO MENOR AL PROMEDIO DE TODOS LOS AÑOS
  void search_lower_prom_years(Nodo nodo, int index, int cant_nodos) {
    if (nodo != null) {
      search_lower_prom_years(nodo.left, index, cant_nodos);
      if ((float)acum_temp_years/cant_nodos > nodo.temperatures.get(index)) {
        nodos_above_prom.add(nodo);
      }
      search_lower_prom_years(nodo.right, index, cant_nodos);
    }
  }
  //  TEMPERATURA PROMEDIO MAYOR O IGUAL A UN VALOR DADO
  void search_greater_value(Nodo nodo, double value) {
    if (nodo != null) {
      search_greater_value(nodo.left, value);
      if (nodo.prom_temp >= value) {
        nodos_greater_value.add(nodo);
      }
      search_greater_value(nodo.right, value);
    }
  }

  // ================== INSERCIÓN ==================
  void insert(Nodo node) {
    root = insert(root, node);
  }

  Nodo insert(Nodo root, Nodo node) {
    if (root == null) {
      return node;
    }

    if (node.prom_temp < root.prom_temp) {
      root.left = insert(root.left, node);
    } else if (node.prom_temp > root.prom_temp) {
      root.right = insert(root.right, node);
    } else {
      return root; // no duplicados
    }

    // actualizar altura
    root.altura = 1 + max(altura(root.left), altura(root.right));

    // rebalancear
    int balanceo = factor_balanceo(root);

    // Caso LL
    if (balanceo < -1 && node.prom_temp < root.left.prom_temp) {
      return right_rotation(root);
    }
    // Caso RR
    if (balanceo > 1 && node.prom_temp > root.right.prom_temp) {
      return left_rotation(root);
    }
    // Caso LR
    if (balanceo < -1 && node.prom_temp > root.left.prom_temp) {
      root.left = left_rotation(root.left);
      return right_rotation(root);
    }
    // Caso RL
    if (balanceo > 1 && node.prom_temp < root.right.prom_temp) {
      root.right = right_rotation(root.right);
      return left_rotation(root);
    }

    return root;
  }

  // ================== ELIMINACIÓN ==================
  Nodo eliminar(double valor) {
    root = eliminar(root, valor);
    return root;
  }

  /*Nodo eliminar(Nodo nodo, double valor) {
   if (nodo == null) {
   return null;
   }
   
   if (valor < nodo.prom_temp) {
   nodo.left = eliminar(nodo.left, valor);
   } else if (valor > nodo.prom_temp) {
   nodo.right = eliminar(nodo.right, valor);
   } else {
   // nodo encontrado
   if (nodo.left == null && nodo.right == null) {
   return null; // hoja
   } else if (nodo.left == null) {
   return nodo.right; // un hijo derecho
   } else if (nodo.right == null) {
   return nodo.left; // un hijo izquierdo
   } else {
   // dos hijos → usar sucesor (menor de los mayores)
   Nodo sucesor = nodoSucesor(nodo.right);
   nodo.prom_temp = sucesor.prom_temp;
   nodo.id = sucesor.id;
   nodo.country = sucesor.country;
   nodo.ISO3 = sucesor.ISO3;
   nodo.temperatures = sucesor.temperatures;
   nodo.right = eliminar(nodo.right, sucesor.prom_temp);
   }
   }
   
   // actualizar altura
   nodo.altura = 1 + max(altura(nodo.left), altura(nodo.right));
   
   // rebalancear
   int balance = factor_balanceo(nodo);
   
   // Caso LL
   if (balance < -1 && factor_balanceo(nodo.left) <= 0) {
   return right_rotation(nodo);
   }
   // Caso LR
   if (balance < -1 && factor_balanceo(nodo.left) > 0) {
   nodo.left = left_rotation(nodo.left);
   return right_rotation(nodo);
   }
   // Caso RR
   if (balance > 1 && factor_balanceo(nodo.right) >= 0) {
   return left_rotation(nodo);
   }
   // Caso RL
   if (balance > 1 && factor_balanceo(nodo.right) < 0) {
   nodo.right = right_rotation(nodo.right);
   return left_rotation(nodo);
   }
   
   return nodo;
   }
   
   Nodo nodoSucesor(Nodo nodo) {
   Nodo actual = nodo;
   while (actual.left != null) {
   actual = actual.left;
   }
   return actual;
   }*/
  Nodo eliminar(Nodo root, double key) {
    if (root == null) {
      return null;
    }

    // 1. Buscar nodo a eliminar
    if (key < root.prom_temp) {
      root.left = eliminar(root.left, key);
    } else if (key > root.prom_temp) {
      root.right = eliminar(root.right, key);
    } else {
      // Nodo encontrado

      // Caso 1: sin hijos o con un solo hijo
      if (root.left == null || root.right == null) {
        Nodo temp = (root.left != null) ? root.left : root.right;

        if (temp == null) {
          // sin hijos
          root = null;
        } else {
          // un solo hijo
          root = temp;
        }
      } else {
        // Caso 2: dos hijos → sucesor inorder
        Nodo sucesor = minValueNode(root.right);

        // Copiar datos del sucesor al nodo actual
        root.prom_temp = sucesor.prom_temp;
        root.ISO3 = sucesor.ISO3;
        root.country = sucesor.country;
        root.temperatures = sucesor.temperatures;

        // Eliminar el sucesor del subárbol derecho
        root.right = eliminar(root.right, sucesor.prom_temp);
      }
    }

    // Si el árbol solo tenía un nodo
    if (root == null) {
      return root;
    }

    // 2. Actualizar altura
    root.altura = 1 + max(altura(root.left), altura(root.right));

    // 3. Factor de balanceo
    int balanceo = factor_balanceo(root);

    // 4. Rebalancear según el caso
    // LL
    if (balanceo < -1 && factor_balanceo(root.left) <= 0) {
      return right_rotation(root);
    }
    // LR
    if (balanceo < -1 && factor_balanceo(root.left) > 0) {
      root.left = left_rotation(root.left);
      return right_rotation(root);
    }
    // RR
    if (balanceo > 1 && factor_balanceo(root.right) >= 0) {
      return left_rotation(root);
    }
    // RL
    if (balanceo > 1 && factor_balanceo(root.right) < 0) {
      root.right = right_rotation(root.right);
      return left_rotation(root);
    }

    return root;
  }

  // Encontrar el nodo con valor mínimo en un subárbol (sucesor inorder)
  Nodo minValueNode(Nodo nodo) {
    Nodo actual = nodo;
    while (actual.left != null) {
      actual = actual.left;
    }
    return actual;
  }


  // ================== UTILIDADES ==================
  int factor_balanceo(Nodo node) {
    if (node == null) return 0;
    return altura(node.right) - altura(node.left); // derecha - izquierda
  }

  int altura(Nodo node) {
    if (node == null) return 0;
    return node.altura;
  }

  // ================== ROTACIONES ==================
  Nodo left_rotation(Nodo nodeX) {
    Nodo nodeY = nodeX.right;
    Nodo subTree = nodeY.left;

    // rotación
    nodeY.left = nodeX;
    nodeX.right = subTree;

    // actualizar alturas
    nodeX.altura = 1 + max(altura(nodeX.left), altura(nodeX.right));
    nodeY.altura = 1 + max(altura(nodeY.left), altura(nodeY.right));

    return nodeY;
  }

  Nodo right_rotation(Nodo nodeY) {
    Nodo nodeX = nodeY.left;
    Nodo subTree = nodeX.right;

    // rotación
    nodeX.right = nodeY;
    nodeY.left = subTree;

    // actualizar alturas
    nodeY.altura = 1 + max(altura(nodeY.left), altura(nodeY.right));
    nodeX.altura = 1 + max(altura(nodeX.left), altura(nodeX.right));

    return nodeX;
  }

  // ================ RECORRIDOS =================
  void recorridoPorNiveles() {
    int h = altura(root);
    for (int i = 1; i <= h; i++) {
      recorrerNivel(root, i);
      //println();
    }
  }

  // imprime todos los nodos en un nivel específico
  void recorrerNivel(Nodo nodo, int nivel) {
    if (nodo == null) return;

    if (nivel == 1) {
      recorrido_niveles += ","+ nodo.ISO3;
      //print(nodo.ISO3);
    } else {
      recorrerNivel(nodo.left, nivel - 1);
      recorrerNivel(nodo.right, nivel - 1);
    }
  }

  //obtener nivel de un nodo
  int obtenerNivel(Nodo raiz, double valor) {
    return obtenerNivelRec(raiz, valor, 1);
  }

  int obtenerNivelRec(Nodo nodo, double valor, int nivel) {
    if (nodo == null) {
      return 0;
    }
    if (nodo.prom_temp == valor) {
      return nivel;
    }
    // buscar en subárbol izquierdo
    if (valor < nodo.prom_temp) {
      return obtenerNivelRec(nodo.left, valor, nivel + 1);
    } else {
      return obtenerNivelRec(nodo.right, valor, nivel + 1);
    }
  }

  //Obtener abuelo
  Nodo abuelo(Nodo root, double element) {
    ArrayList<Nodo> resultado = search_iterative(root, element);
    Nodo nodo = resultado.get(0);
    Nodo padre = resultado.get(1);

    if (padre == null) {
      return null;
    }

    // Buscar al padre dentro del árbol para obtener su propio padre
    ArrayList<Nodo> resPadre = search_iterative(root, padre.prom_temp);
    Nodo abuelo = resPadre.get(1);

    return abuelo;
  }

  Nodo tio(Nodo root, double element) {
    ArrayList<Nodo> resultado = search_iterative(root, element);
    Nodo nodo = resultado.get(0);
    Nodo padre = resultado.get(1);

    if (padre == null) {
      return null; // si no hay padre, no hay tío
    }

    Nodo abuelo = abuelo(root, element);
    if (abuelo == null) {
      return null; // sin abuelo no hay tío
    }

    if (abuelo.left == padre) {
      return abuelo.right; // el otro hijo
    } else {
      return abuelo.left;
    }
  }
}
