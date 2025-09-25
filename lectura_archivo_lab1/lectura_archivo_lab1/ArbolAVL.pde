class ArbolAVL {
  Nodo root;

  //Búsqueda
  Nodo search(Nodo root, double valor) {
    if (root == null) return null;
    if (valor == root.prom_temp) return root;
    if (valor < root.prom_temp) return search(root.left, valor);
    else return search(root.right, valor);
  }

  //Inserción
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

  //Eliminación
  void eliminar(double valor) {
    root = eliminar(root, valor);
  }

  Nodo eliminar(Nodo nodo, double valor) {
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
        // dos hijos, se usa sucesor
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

    // Caso RR
    if (balance < -1 && factor_balanceo(nodo.left) <= 0) {
      return right_rotation(nodo);
    }
    // Caso DLR
    if (balance < -1 && factor_balanceo(nodo.left) > 0) {
      nodo.left = left_rotation(nodo.left);
      return right_rotation(nodo);
    }
    // Caso LF
    if (balance > 1 && factor_balanceo(nodo.right) >= 0) {
      return left_rotation(nodo);
    }
    // Caso DRL
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
  }

  int factor_balanceo(Nodo node) {
    if (node == null) return 0;
    return altura(node.right) - altura(node.left);
  }

  int altura(Nodo node) {
    if (node == null) return 0;
    return node.altura;
  }

  // Rotaciones
  Nodo left_rotation(Nodo nodeX) {
    Nodo nodeY = nodeX.right;
    Nodo subTree = nodeY.left;

    // rotación
    nodeY.left = nodeX;
    nodeX.right = subTree;

    // actualizar alturas
    nodeX.altura = 1 + max(altura(nodeX.left), altura(nodeX.right));
    nodeY.altura = 1 + max(altura(nodeY.left), altura(nodeY.right));

    println("Rotación Izquierda (LR) en nodo " + nodeX.ISO3 +" " + nodeX.prom_temp);
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

    println("Rotación Derecha (RR) en nodo " + nodeX.ISO3 +" " + nodeY.prom_temp);
    return nodeX;
  }
  
  // Recorrido niveles
  void recorridoPorNiveles() {
    int h = altura(root);
    for (int i = 1; i <= h; i++) {
      recorrerNivel(root, i);
      println();
    }
  }
  
  // imprime todos los nodos en un nivel específico
  void recorrerNivel(Nodo nodo, int nivel) {
    if (nodo == null) return;
  
    if (nivel == 1) {
      print(nodo.ISO3);
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
}
