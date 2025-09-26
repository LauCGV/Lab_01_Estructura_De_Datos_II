 //<>//
class Vista {
  Boolean pantalla1;
  Boolean pantalla2;
  Boolean pantalla3;
  Boolean pantalla4;
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
      tf_buscarProm.hide();
      tf_buscarAño1.hide();
      tf_buscarAño2.hide();
      tf_buscarValor.hide();
      tl_obtenerISO.hide();
      tl_nISO.hide();
      tl_nPAIS.hide();
    } else {
      tf_insertar.show();
      tf_eliminar.show();
      tf_buscarProm.show();
      tf_buscarAño1.show();
      tf_buscarAño2.show();
      tf_buscarValor.show();
      tl_obtenerISO.show();
      tl_nISO.show();
      tl_nPAIS.show();
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

    tf_buscarProm = cp5.addTextfield("tf_buscarProm")
      .setPosition(width* 0.104, height*0.453)
      .setSize( int(width*0.151), int(height*0.046))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tf_buscarProm.setColorBackground(color(#ddbce6)); // fondo
    tf_buscarProm.setColorForeground(color(#ddbce6));     // borde
    tf_buscarProm.setColorActive(color(#ddbce6));     // activo
    tf_buscarProm.getCaptionLabel().hide();           // ocultar etiqueta

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
    
    tl_nISO = cp5.addTextfield("tl_nISO")
      .setPosition(width* 0.015, height*0.324)
      .setSize( int(width*0.067), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tl_nISO.setColorBackground(color(#ddbce6)); // fondo
    tl_nISO.setColorForeground(color(#ddbce6));     // borde
    tl_nISO.setColorActive(color(#ddbce6));     // activo
    tl_nISO.getCaptionLabel().hide();           // ocultar etiqueta
    
    tl_nPAIS = cp5.addTextfield("tl_nPAIS")
      .setPosition(width* 0.109, height*0.324)
      .setSize( int(width*0.151), int(height*0.037))
      .setFont(createFont("Arial", 20))
      .setFocus(true)
      .setColor(color(0))        // color del texto
      .setColorCursor(color(0))
      .setAutoClear(false);

    tl_nPAIS.setColorBackground(color(#ddbce6)); // fondo
    tl_nPAIS.setColorForeground(color(#ddbce6));     // borde
    tl_nPAIS.setColorActive(color(#ddbce6));     // activo
    tl_nPAIS.getCaptionLabel().hide();           // ocultar etiqueta
  }
}
