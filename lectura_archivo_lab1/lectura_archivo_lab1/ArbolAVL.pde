class ArbolAVL {
  Nodo root;

  // ================== BÚSQUEDA ==================
  Nodo search(Nodo root, double valor) {
    if (root == null) return null;
    if (valor == root.prom_temp) return root;
    if (valor < root.prom_temp) return search(root.left, valor);
    else return search(root.right, valor);
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

    println("Rotación Izquierda (RR) en nodo " + nodeX.prom_temp);
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

    println("Rotación Derecha (LL) en nodo " + nodeY.prom_temp);
    return nodeX;
  }
}
