// Práctica 1 de Simulación
// Miguel Lozano / Francisco Martínez Gil / Jesús Gimeno
// Curso 16-17

final int EULER = 0;
final int EULER_SEMI = 1;
final int RK2 = 2;
final int HEUN = 3;
final int RK4 = 4;

// Extremos 
Extremo Extr = new Extremo(width*.5, height*.5);
Extremo Fijo = new Extremo(width*.25, height*.5);
Muelle Muell = new Muelle(Fijo, Extr);


float v_inicial;

void setup() 
{
  size(640, 360);

  //Crear objetos en su posición inicial
  v_inicial = 5;
  Extr = new Extremo(width*.625, height*.5, v_inicial);
  Fijo = new Extremo(width*.25, height*.5);

  Muell = new Muelle(Fijo, Extr);
}

void draw() 
{
  background(255); 

  //***************************************************
  // SIMULACIÓN
  //***************************************************

  strokeWeight(2);
  stroke(0);

  line(0, height*0.5 - 10, width*0.25, height*0.5 - 10);
  line(width*0.25, height*0.5 - 10, width*0.25, height*0.5 + 10);
  line(width*0.25, height*0.5 + 10, width, height*0.5 + 10);

  Muell.update();
  Muell.display();

  Extr.update(RK4);
  Extr.display();
  Extr.drag(mouseX);

  v_inicial = 5;
  
  float sol_analitica = sqrt((Muell.k/Extr.mass)*Muell.len*Muell.len+v_inicial*v_inicial);

  float error = abs(Extr.velocity-sol_analitica);
}

void mousePressed() 
{
  Extr.clicked(mouseX, mouseY);
}

void mouseReleased() 
{
  Extr.stopDragging();
}


class Extremo 
{ 
  float location, location_otro_extremo;
  float velocity;
  float acceleration;
  float mass = 10.0, dt = 0.2;

  float force;

  float k;
  float len_reposo;

  // Damping arbitrario para simular fricción o resistencia del aire 
  float damping = 0.5;

  // Interacción con el ratón
  PVector dragOffset;
  PVector amortiguamiento;
  boolean dragging = false;

  // Constructor
  Extremo(float x, float y) 
  {
    location = x;
    velocity = 0;
    acceleration = 0;
    dragOffset = new PVector(0, 0);
    force = 0;
  } 

  //Constructor con velocidad incial
  Extremo(float x, float y, float v_ini) {
    location = x;
    velocity = v_ini;
    acceleration = 0;
    dragOffset = new PVector() ;
    force = 0;
  } 

  void actualizarParametros(float l, float k2, float lenrep)
  {
    location_otro_extremo = l;
    k = k2;
    len_reposo = lenrep;
  }

  //le pasamos la localizacion
  //devuelve la aceleracion
  float aplicaFuerza(float loc_actual)
  {
    float len = loc_actual-location_otro_extremo;
    force = -k*(len-len_reposo);
    float acc = applyForce(force);
    return acc;
  }

  // Integración de la posición del extremo en función de las fuerzas/aceleraciones acumuladas
  void update(int mode) 
  {
    acceleration = aplicaFuerza(location);

    switch(mode) 
    {
    case EULER:
      location = location + velocity * dt;
      velocity = velocity + acceleration * dt;
      break;
    case EULER_SEMI:
      velocity = velocity + acceleration * dt;
      location = location + velocity * dt;
      break;
    case RK2:
      float location2, velocity2, acceleration2;
      location2 = location + velocity*dt;
      velocity2 = velocity + acceleration*dt;
      acceleration2 = aplicaFuerza(location2);
      location = location + (velocity + velocity2)*dt/2;
      velocity = velocity + (acceleration2 + acceleration)*dt/2;
      break;
    case RK4:
      float location3, velocity3, acceleration3, location4, velocity4, acceleration4, location5, velocity5, acceleration5;
      location3 = location + velocity*dt/2;
      velocity3 = velocity + acceleration*dt/2;
      acceleration3 = aplicaFuerza(location3);

      location4 = location + velocity3*dt/2;
      velocity4 = velocity + acceleration3*dt/2;
      acceleration4 = aplicaFuerza(location4);

      location5 = location + velocity4*dt;
      velocity5 = velocity + acceleration4*dt;
      acceleration5 = aplicaFuerza(location5);

      float velsum = velocity + velocity3*2+velocity4*2+velocity5;
      float accsum = acceleration + acceleration3*2+acceleration4*2+acceleration5;

      location = location + velsum*dt/6;
      velocity = velocity + accsum*dt/6;
      break;
    }
  }

  // Ley de Newton: F = M * A
  float applyForce(float force) 
  {
    // Dado el vector fuerza, conseguir la aceleración y aplicarla al extremo
    float acc;
    acc = force/mass;  // A = F / M
    return acc;
  }


  // Dibujo el extremo como un circulo de radio proporcional a su peso
  void display() 
  { 
    stroke(0);
    strokeWeight(2);
    fill(75, 120);
    if (dragging) 
    {
      fill(0);
    }

    ellipse(location, height*.5,mass*2,mass*2);
  } 

  //***********************************************************
  // Métodos para interacción con el ratón
  //***********************************************************

  // Comprobación de si se hace click sobre un extremo
  void clicked(int mx, int my) 
  {
    float d = dist(mx, my, location, height*0.5);
    if (d < mass) 
    {
      dragging = true;
      dragOffset.x = location-mx;
    }
  }

  // Detener el movimiento del extremo porque se ha soltado el botón del ratón
  void stopDragging() 
  {
    dragging = false;
  }

  // Mover el extremo con el ratón cuando se ha hecho click sobre él
  void drag(int mx) 
  {
    if (dragging && mx >= width*0.25 + mass) 
    {
      location = mx + dragOffset.x;
      velocity = 0;
    }
  }
}

class Muelle 
{  
  // Constantes de configuración del muelle
  float len;
  float len_reposo;
  float k = 15.0;
  float fuerza;
  
  //Extremos del muelle
  Extremo a;
  Extremo b;

  // Constructor
  Muelle(Extremo a_, Extremo b_) { 
    a = a_;
    b = b_;
    len_reposo = b.location - a.location;
    len = b.location-a.location;
  } 

  // Calculate spring force
  void update() 
  {
    //Aplicar la fuerza del muelle de acuerdo con la ley de Hook.
    
    len = b.location-a.location;
    
    
    b.actualizarParametros(a.location, k, len_reposo);
    b.force = fuerza;
    
    //Recuerda que en un muelle aparecen DOS fuerzas contrarias y de igual magnitud que fuerzan al muelle a recuperearse 

    //Definiendo la fuerza como un PVector de processing puede ser útil usar los siguiente métodos
    //fuerza.mag() devuelve el módulo
    //fuerza.normalize()  normaliza el vector
    //fuerza.mult(h)  multiplica elvector por el escalar h  

  }

  //Dibuja una linea recta que representa al muelle
  void display() 
  {
    strokeWeight(2);
    stroke(0);
    line(a.location, height*.5, b.location, height*.5);
  }
}