//Bubble Shooter

float x, y;
float dt = 0.01;
float v = 0.005;
boolean disparo = false;
float dx = 0.0, dy=0.0;
float modMouse;

void setup() {
  size(500, 500);
}
void draw() {
  background(200);

  PVector mouse = new PVector(mouseX, mouseY);
  PVector center = new PVector(width/2, height/2);

  mouse.sub(center);
  modMouse = sqrt((mouse.x*mouse.x)+(mouse.y*mouse.y));
  mouse.x /= modMouse;
  mouse.y /= modMouse;
  mouse.mult(100);

  translate(width/2, height/2);
  line(0, 0, mouse.x, mouse.y);
  fill(255, 0, 0);

  if (mousePressed) {
    disparo = true;
  }

  if (disparo==true) {

    fill(255, 0, 0);
    ellipse(mouse.x + dx, mouse.y + dy, 15, 15);
    dx += v*dt + (mouse.x/8);
    dy += v*dt + (mouse.y/8);

    if (dx > width || dy > height) {
      disparo=false;
    } else {
      disparo=false;
    }
  } else {
    disparo=false;
    dx=0.0;
    dy=0.0;
  }
}