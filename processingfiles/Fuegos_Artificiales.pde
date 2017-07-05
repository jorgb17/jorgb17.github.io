// Práctica 2 - Simulación

ArrayList<Cohete> castillo;
int npart = 0;
float dt = 0.1;

//viento
PVector viento;
int tipo=1;

void setup() {
  size(1200, 720);
  //el castillo es un array de cohetes
  viento = new PVector(0, 0);
  castillo = new ArrayList<Cohete>();
  npart = 0;

}

void draw() {
  background(0);

  for (int i=0; i<castillo.size(); i++) {
    Cohete c = castillo.get(i);
    c.run();
  }

  //escribe en la pantalla el numero de particulas actuales

  fill(255);
  text("Frame-Rate: " + frameRate, 15, 15);
  text("Numero de particulas: " + npart, 15, 35);
  text("Direccion del viento en el eje x: " + viento.x, 15, 55);
  text("Direccion del viento en el eje y:" + viento.y, 15, 75);
  text("Utiliza las flechas del teclado para cambiar", 840, 15);
  text("la dirección del viento", 840, 35);
}

//Podeis usar esta funcion para controlar el lanzamiento delcastillo
//cada vez que se pulse el rat�n se lanza otro cohete
//puede haber simultaneamente varios cohetes  (castillo = vector de cohetes )
void mousePressed() {
  PVector pos = new PVector(mouseX, mouseY);

  //--->definir un color.Puede ser aleatorio usando random()
  color miColor = color(random(0, 255), random(0, 255), random(0, 255));

  //--->el tipo de cohete será aleatorio (circular, cono,eliptico,....)
  Cohete c = new Cohete (pos, miColor, tipo);
  castillo.add(c);
}

void keyPressed()
{
  if (keyCode == LEFT)
    viento.x--;

  if (keyCode == RIGHT)
    viento.x++;

  if (keyCode == UP)
    viento.y--;

  if (keyCode == DOWN)
    viento.y++;
  
  if (key == '1')
    tipo=1;

  if (key == '2')
    tipo=2;

  if (key == '3')
    tipo=3;

  if (key == '4')
    tipo=4;
  
  if (key == '5')
    tipo=5;
} 

class Cohete {
  //el cohete tiene dos tipos de particulas: la carcasa (una sola) y elsistema de particulas (vector) que forman los puntos de luz
  Particle carcasa;
  ArrayList<Particle> particles;

  //lugar de donde sale la particula
  PVector origin;

  //el tipo sirve para controlar desde la clase castillo,el tipo de artefacto pirotecnico que se va a simular
  //podeis implementar diferentes explosiones:circulares, en cono hacia arriba, en cono hacia abajo, elipticas ...
  int type;

  color colorParticulas;

  //esta bandera sirve para indicar cuando se debe explotar la carcasa y pasar de una particula a un sistema de particulas
  boolean explotar;

  int time2liveParticulas;

  Cohete(PVector location, color c, int tipo) {
    origin = location.get();

    //array de particulas luminosas.Aun NO SE CREAN las particulas concretas
    particles = new ArrayList<Particle>();
    colorParticulas = c;
    explotar = true;
    type = tipo;
    time2liveParticulas = 100;
    //Este metodo crea la particula carcasa
    crearCarcasa(location);
  }

  void crearCarcasa(PVector loc) {

    //--->se deben de configurar todos los parametros de la carcasa, en concreto  su velocidad inicial (que podeis hacer variable dentro de unos limites)
    //--->tambien el retardo de la explosion

    //--->PVector velocidad = new PVector(.....;
    //--->carcasa = new Particle(....;
    PVector v_inicial = new PVector(0, -75);
    carcasa = new Particle(loc, v_inicial, time2liveParticulas, "cohete", color(255, 255, 255));
  }

  //el argumento pos del siguiente metodo es la posicion donde explota la carcasa
  //este metodo se llama en run()

  void addParticles(PVector pos) {
    PVector velocidad = new PVector(0, 0);
    float ang = 0;
    int time2liveParticulas = int(random(50, 150));

    switch (type) {
      //Cohete que genera palmera
    case 1:
      for (int i=0; i<360; i++) {

        float v = random(1, 10);
        //--->preparar una velocidad con una nueva direccion
        velocidad = new PVector(v, v);

        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);
        //--->añadir al vector particles una o varias particulas en esa direccion 
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 2:
      // Cohete que forma un circulo
      for (int i=0; i<360; i++) {
        //float v = random(1, 10);
        velocidad = new PVector(random(5, 5.5), random(5, 5.5));
        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 3:
      //Cohete que forma una espiral
      for (int i=0; i<360; i++) {
        ang = random(0, 2*TWO_PI);
        velocidad = new PVector(2*ang, 2*ang);
        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 4:
      //Cohete que forma corazones
      for (int i=0; i<360; i++) {
        ang = random(0, 2*TWO_PI);
        velocidad = new PVector(-(3*sin(ang)-1*sin(3*ang)), -(3.25*cos(ang)-1.25*cos(2*ang)-0.5*cos(3*ang)-0.25*cos(4*ang)));
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;
    
    case 5:
     //Cohetes aleatorios
     {
     switch (int(random(0,5))) {
      //Cohete que genera palmera
    case 1:
      for (int i=0; i<360; i++) {

        float v = random(1, 10);
        //--->preparar una velocidad con una nueva direccion
        velocidad = new PVector(v, v);

        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);
        //--->añadir al vector particles una o varias particulas en esa direccion 
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 2:
      // Cohete que forma un circulo
      for (int i=0; i<360; i++) {
        //float v = random(1, 10);
        velocidad = new PVector(random(5, 5.5), random(5, 5.5));
        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 3:
      //Cohete que forma una espiral
      for (int i=0; i<360; i++) {
        ang = random(0, 2*TWO_PI);
        velocidad = new PVector(2*ang, 2*ang);
        velocidad.x = velocidad.x*cos(ang);
        velocidad.y = velocidad.y*sin(ang);

        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
      break;

    case 4:
      //Cohete que forma corazones
      for (int i=0; i<360; i++) {
        ang = random(0, 2*TWO_PI);
        velocidad = new PVector(-(3*sin(ang)-1*sin(3*ang)), -(3.25*cos(ang)-1.25*cos(2*ang)-0.5*cos(3*ang)-0.25*cos(4*ang)));
        Particle p = new Particle(pos, velocidad, time2liveParticulas, "particula", colorParticulas);
        particles.add(p);

        ang += 2 * PI / 360;
      }
    }
     }
    }
  }

  //Funcion de control del cohete que no deberiais tocar
  void run() {

    if (!carcasa.isDead()) { 
      //Simulacion carcasa
      carcasa.run();
    } else if (carcasa.isDead() && explotar) {
      //Frame de preparacion de las particulas para la  explosion
      npart--;
      explotar = false;

      //aqui se reservan los objetos particula
      addParticles(carcasa.getLocation());
    } else {
      //Simulacion de la palmera pirotécnica (sistema de particulas)
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.run();
        if (p.isDead()) {
          npart--;
          //Si la particula ha agotado su existencia, se elimina del vector usando el metodo remove() de la clase ArrayList
          particles.remove(i);
        }
      }
    }
  }
}

class Particle {
  PVector F;
  PVector acceleration;
  PVector velocity;
  PVector location;
  PVector gravity;

  float masa;
  float lifespan;
  int ttl;
  boolean anyadida;

  //Hay dos tipos de particula identificada por una etiqueta
  //El tipo "carcasa" es una particula de gran tama�o que simular� en su ascensi�n la carcasa
  //El tipo "particula" que representa un punto de color cuando la carcasa haya explotado
  String tipo;

  color Color;

  Particle(PVector l, PVector v, int time2live, String type, color c) {
    F = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    velocity = v.get();
    location = l.get();

    masa = 1;

    ttl = time2live;
    anyadida = false;
    tipo = type;
    Color = c;
  }


  void run() {
    //---> Solo la primera vez que se ejecute run(), se aumenta npart
    //para ello usar el atributo 'anyadida '  que se pondra a true la primera vez,cuando se cuenta la particula
    if (!anyadida)
    {
      npart++;
      anyadida = true;
    }

    update();
    display();
  }

  // Method to update location
  void update() {
    actualizaFuerza();

    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration = new PVector(F.x/masa, F.y/masa);

    //--->utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.x = velocity.x + acceleration.x*dt;
    velocity.y = velocity.y + acceleration.y*dt;

    location.x = location.x + velocity.x*dt;
    location.y = location.y + velocity.y*dt;

    ttl--;  //descuenta el tiempo de vida de la particula
  }

  void actualizaFuerza() {

    //--->la fuerza tiene dos componentes. En uno, siempre  actua la gravedad
    //la fuerza del viento se puede acoplara la otra componente de la fuerza de la particula (o incluso a las dos)
    gravity = new PVector(0, 9.8);

    F.x = gravity.x+viento.x;
    F.y = gravity.y+viento.y;
  }

  PVector getLocation() {
    return location;
  }

  // Method to display
  void display() {
    if (tipo == "particula") {
      stroke(Color, ttl);
      fill(Color, ttl);
      ellipse(location.x, location.y, 2, 2);
    } else {
      stroke(255);
      fill(255);
      ellipse(location.x, location.y, 5, 5);
    }
  }

  // Sirve para eliminar de la clase cohete a dicha particula
  boolean isDead() {
    if (ttl < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}