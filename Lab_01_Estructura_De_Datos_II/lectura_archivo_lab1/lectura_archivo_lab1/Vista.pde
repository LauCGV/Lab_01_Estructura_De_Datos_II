 //<>//
class Vista {
  Boolean pantalla1;
  Boolean pantalla2;
  Boolean pantalla3;
  Boolean panelNiveles;
  PImage fondo;

  public Vista() {
    this.pantalla1 = true;
    this.pantalla2 = false;
    this.pantalla3 = false;
    this.panelNiveles = false;
    this.fondo = null;
  }

  public void mostrarPantallaPrincipal() {
    image(fondo1, 0, 0, width, height);
  }
  public void mostrarMenuPrincipal() {
    image(fondoMenu, 0, 0, width, height);
  }
  public void mostrarPanelRecorrido() {
    
  }
  public void ocultarTextFieldsMenu(Boolean x) {
    if (x == true) {
      tf_insertar.hide();
      tf_eliminar.hide();
      tf_buscarISO.hide();
      tf_buscarAño1.hide();
      tf_buscarAño2.hide();
      tf_buscarValor.hide();
      tl_obtenerISO.hide();
    } else {
      tf_insertar.show();
      tf_eliminar.show();
      tf_buscarISO.show();
      tf_buscarAño1.show();
      tf_buscarAño2.show();
      tf_buscarValor.show();
      tl_obtenerISO.show();
    }
  }
  public void mostrarTextfieldsPantalla2() {
      


    tf_insertar = cp5.addTextfield("tf_insertar")
      .setPosition(width* 0.098, height*0.175)
      .setSize( int(width*0.161), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_insertar.setColorBackground(color(#ddbce6)); // fondo
    tf_insertar.setColorForeground(color(#ddbce6));     // borde
    tf_insertar.setColorActive(color(#ddbce6));     // activo
    tf_insertar.getCaptionLabel().hide();           // ocultar etiqueta

    tf_eliminar = cp5.addTextfield("tf_eliminar")
      .setPosition(width* 0.100, height*0.231)
      .setSize( int(width*0.161), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_eliminar.setColorBackground(color(#ddbce6)); // fondo
    tf_eliminar.setColorForeground(color(#ddbce6));     // borde
    tf_eliminar.setColorActive(color(#ddbce6));     // activo
    tf_eliminar.getCaptionLabel().hide();           // ocultar etiqueta

    tf_buscarISO = cp5.addTextfield("tf_buscarISO")
      .setPosition(width* 0.104, height*0.453)
      .setSize( int(width*0.151), int(height*0.046))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_buscarISO.setColorBackground(color(#ddbce6)); // fondo
    tf_buscarISO.setColorForeground(color(#ddbce6));     // borde
    tf_buscarISO.setColorActive(color(#ddbce6));     // activo
    tf_buscarISO.getCaptionLabel().hide();           // ocultar etiqueta

    tf_buscarAño1 = cp5.addTextfield("tf_buscarAño1")
      .setPosition(width* 0.177, height*0.546)
      .setSize( int(width*0.088), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_buscarAño1.setColorBackground(color(#ddbce6)); // fondo
    tf_buscarAño1.setColorForeground(color(#ddbce6));     // borde
    tf_buscarAño1.setColorActive(color(#ddbce6));     // activo
    tf_buscarAño1.getCaptionLabel().hide();           // ocultar etiqueta

    tf_buscarAño2 = cp5.addTextfield("tf_buscarAño2")
      .setPosition(width* 0.177, height*0.629)
      .setSize( int(width*0.088), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_buscarAño2.setColorBackground(color(#ddbce6)); // fondo
    tf_buscarAño2.setColorForeground(color(#ddbce6));     // borde
    tf_buscarAño2.setColorActive(color(#ddbce6));     // activo
    tf_buscarAño2.getCaptionLabel().hide();           // ocultar etiqueta

    tf_buscarValor = cp5.addTextfield("tf_buscarValor")
      .setPosition(width* 0.177, height*0.712)
      .setSize( int(width*0.088), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_buscarValor.setColorBackground(color(#ddbce6)); // fondo
    tf_buscarValor.setColorForeground(color(#ddbce6));     // borde
    tf_buscarValor.setColorActive(color(#ddbce6));     // activo
    tf_buscarValor.getCaptionLabel().hide();           // ocultar etiqueta

    tl_obtenerISO = cp5.addTextfield("tl_obtenerISO")
      .setPosition(width* 0.130, height*0.851)
      .setSize( int(width*0.125), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tl_obtenerISO.setColorBackground(color(#ddbce6)); // fondo
    tl_obtenerISO.setColorForeground(color(#ddbce6));     // borde
    tl_obtenerISO.setColorActive(color(#ddbce6));     // activo
    tl_obtenerISO.getCaptionLabel().hide();           // ocultar etiqueta
  }
}
