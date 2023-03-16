import gifAnimation.*; //libreria para el uso de gifs
import ddf.minim.*; //libreria para el uso de audios
import processing.video.*; //Libreria para el procesamiento de video
import processing.serial.*;

PImage[] animation;
char LetraNew, Letra; 
Serial MiPuerto;
//Declaracion de valores
int screen; // variable que define en que pantalla de juego se esta.
//Audio
Minim minim0, minim1, minim2, minim3;
AudioPlayer songMenu, songL1, songL2, exploteL2, songL3, exploteL3;
//Video
Movie movie, movie2, movie3, creditos;
boolean press = false;
boolean press2 = false;
boolean press3 = false;
char change = 'w'; 
char lastLetra = 'e';
//Juego 1
Gif menu, insectoF, insecto, point;
int insectoX=0, insectoY=0; 
int pointX = 800; // Posición inicial del punto en X
float pointY = 415; 
float pointSpeed = 13; // Velocidad del robot
int scoreL1 = 0;
float insectoHeight = 50;
boolean collision = false;
//Juego 2
Gif background, alien, robot, alienJump, explosion;
int groundLevel = 410; // Nivel del suelo
float alienX = 100; // Posición inicial del alien
float alienY = groundLevel; // Altura inicial del alien
float alienVelocity = 1000; // Velocidad inicial del alien
boolean isJumping = false; // Indica si el alien está saltando
int robotX = 800; // Posición inicial del robot
int robotY= groundLevel; //Altura inicial del robot
float robotSpeed = 8; // Velocidad inicial del robot
float gravity; //Gravedad
int scoreL2 = 0; // Puntuación
PFont pixelFont; //Crea tipos de fuentes de texto
//Fuego 3
PImage fondo, jumpR, jumpL, fallR, fallL, shoot,
platform, disp, dQR, dQL;
Gif DQR, DQL, DWR, DWL, enemyAnimation, ex; 
//variables booleanas para validación y comprobación
boolean right=false, left=false, up=false, lookR=true, isJumping_lvl3=false, 
moveBulletR = false, moveBulletL = false, enemy = false, isFalling = false; 
//Algunas varaibles constantes
int xP3 = 5, yP3 = 360; //Posición del jugador en los ejes (iniciales); 
float ySpeed_lvl3 = 0;  //Velocidad del juador en el eje y
int largoP = 450, anchoP = 30; //Son las dimensiones de las plataformas
int ptx1 = 150, pty1 = 400, ptx2 = -100, pty2 = 270 , ptx3 =200 , pty3 = 150; //Posiciones de las plataformas
int limitY = 360, groundlevel_lvl3 = 360; //Valores iniciales (limitY varia su valor dependiendo de las plataformas) 
int heightP = 170, widthP = 152; //Dimensiones de nuestro personaje
float gravity_lvl3 = 0.6; //gravedad
float xEnemy = 1000, yEnemy,spdEnemy, auxX, auxY; //Agregamos un valor a xEnemy para colocarlo inicialmente fuera de pantalla
//El resto de las variables de Enemy obtienen un valor mediante random en la funcion UPDATE
float xBulSpeed = 15; //Velocidad de los disparos
int xBullet, yBullet; //Posiciones del proyectil o disparo 
int score_lvl3 = 0; //Lleva la puntuación del jugador (se incrementa al eliminar enemigos) 
int health_lvl3 = 100; //Lleva el conteo de vida (disminuye al contacto con un enemigo)
int loopF = 0;

void setup() {
  MiPuerto = new Serial(this, "COM13", 115200);
  size(988, 628); //Tamaño de la pantalla
  //Menu
  menu = new Gif(this, "menu.gif"); //Imagen de inicio del menu
  menu.loop();//Comienza la ejecucion del gif
  //Musica
  minim0 = new Minim(this); 
  songMenu = minim0.loadFile("songMenu.mp3"); //Cancion de inicio 
  minim1 = new Minim(this);
  songL1 = minim1.loadFile("songL1.mp3"); // Cancion del nivel 1
  minim2 = new Minim(this);
  songL2 = minim2.loadFile("songL2.mp3"); //Canciones del nivel 2
  exploteL2 = minim2.loadFile("explosion.mp3");
  minim3 = new Minim(this);
  songL3 = minim3.loadFile("songL3.mp3"); //Canciones del nivel 3
  exploteL3 = minim3.loadFile("explosion.mp3");
  //Seleccion de menu
  screen = 0; //Por default selecciona la pantalla de inicio
  //Videos
  movie = new Movie(this, "Level1.mp4"); //Video de transicion al nivel 1
  movie2 = new Movie(this, "Level2.mp4"); //Video de transicion al nivel 2
  movie3 = new Movie(this, "Level3.mp4"); //Video de transicion al nivel 3
  creditos = new Movie(this, "Creditos.mp4"); //Video de creditos finales
  //Juego 1
  insectoF = new Gif(this, "insectoF.gif"); ///Fondo del nivel 1
  insectoF.loop(); //Comienza la ejecucion del gif
  insecto = new Gif(this, "insecto.gif");//Personaje nivel 1
  insecto.loop(); //Comienza la ejecucion del gif
  point = new Gif(this, "point2.gif"); //Puntos a recolectar
  point.loop(); //Comienza la ejecucion del gif
  //Juego 2
  gravity = 0.5; //Gravedad
  background = new Gif(this, "fondo.gif"); //Fondo del nivel 2
  background.loop(); //Comienza la ejecucion del gif
  alien = new Gif(this, "alien.gif"); //Personaje del nivel 2
  alien.loop();//Comienza la ejecucion del gif
  robot = new Gif(this, "enemy.gif");//Enemigo del nivel 2
  robot.loop();//Comienza la ejecucion del gif
  alienJump = new Gif(this, "jumpy.gif"); //Personaje del nivel 2 saltando
  alienJump.loop();//Comienza la ejecucion del gif
  explosion = new Gif(this, "explosion.gif"); //Explosion de colision
  explosion.loop();//Comienza la ejecucion del gif
  //Juego 3
  platform = loadImage("platform.png");  fondo = loadImage("fondoLvl3.png"); //Fondo del nivel 3
  jumpR = loadImage("jump0.png");  jumpL = loadImage("jump1.png"); //Salto izquierda y derecha del personaje 3
  fallR = loadImage("fall0.png");  fallL = loadImage("fall1.png"); //Caida de salto izquierda y derecha del personaje 3
  disp = loadImage("disparo.png"); dQR = loadImage("dsr.png"); dQL = loadImage("dsl.png"); //Personaje disparando y balas
  DQR = new Gif(this, "quietRight.gif"); DQR.loop(); //Personaje derecha parado
  DQL = new Gif(this, "quietLeft.gif"); DQL.loop(); //Personaje izquierda parado
  DWR = new Gif(this, "walksRight.gif"); DWR.loop(); //Personaje derecha caminando
  DWL = new Gif(this, "walksLeft.gif");  DWL.loop(); //Personaje izquierda caminando
  enemyAnimation = new Gif(this, "enemy3.gif"); enemyAnimation.loop(); //Enemigo nivel 2
  ex = new Gif(this, "explosion.gif"); ex.loop(); //Explosion de colision
  // Estilo de texto
  pixelFont = createFont("PixelFont.ttf", 35); //Crear una variable para llamar al archivo de la fuente
}

void draw() { //Menu de niveles
  if (screen == 0) { //Selecion menu
    screen0(); //Menu
  } 
  if (screen == 1){ //Selecion transcion nivel 1
    screen1();
    alienX = 100;
  }
  if (screen == 2){ //Nivel 1
    screen2();
    drawPoint(); //Dibujar puntos
    movePoint(); //Mover los puntos de forma aleatoria en  Y
  }
  if (screen == 3){ //Selecion transcion nivel 2
    screen3();
  }
  if (screen == 4){ //Nivel 2
    screen4();
  }
  if (screen == 5){ //Selecion transcion nivel 3
    screen5();
  }
  if (screen == 6){ //Nivel 3
    screen6();
  }
  if(screen >= 7){ //Presentacion creditos
    if (loopF == 0){ //Continuar con la ejecucion 1 vez
      loop();
      loopF++;
    }
    screen7();
  }
}

void movieEvent(Movie m) { //Clase de la libreria de video para leer videos
  m.read();
}

void screen0(){ //Menu inicial
  background(0); //Fondo en blanco
  image(menu, 0, 0); 
  songMenu.play(); //Reproduccion sonido inicial
  if (keyPressed) { //Continuar al video de transferencia 1 con cualquier tecla
    songMenu.pause();
    screen = 1; //Seleccion de menu
  }
}

void screen1(){ //Reproducir video de transicion 1
  background(0); //Fondo blanco
  image(movie, 0, 0, 988, 628);
  float md = movie.duration(); //Duracion maxima del video
  float mt = movie.time(); //Duracion del video actual
  if (mt >= 3 && press == false ) { //Pausa de continuacion
   movie.pause();
   press = true;
  }
  if (keyPressed && screen == 1) { //Ejecucion continuacion de reproduccion
   movie.play();
  }
  if (mt == md && press == true) { //Cambio despues de terminar el video
   screen = 2;
  }
}

void screen2(){ //Agregar personajes y movimiento al nivel 1
  background(0); //Fondo blanco
  songL1.play(); //Reprocuccion de audio
  image(insectoF, 0, 0, 988,628); 
  image(insecto, insectoX, insectoY, 150, 150);
  showScoreL1();
  moveInsecto();
  if(scoreL1 >= 5){ //Continuar al video de transferencia 2 cuando se alcanzen los puntos necesarios
   songL1.pause();
   screen = 3;
  }
}

void moveInsecto() {
  if (keyPressed) {
     if (keyCode == UP) {
      insectoY -= 15;
    } else if (keyCode == DOWN) {
      insectoY += 15;
    }
  }
  if(LetraNew == 'd'){
    insectoX += 15;
  }
  if(LetraNew == 'i'){
    insectoX -= 15;
  }
}

void drawPoint(){
 image(point, pointX, pointY, 50, 50);
}

void movePoint(){  //Movimiento del punto
   pointX -= pointSpeed;
  // Si el robot se sale de la pantalla, lo volvemos a colocar al final
  if (pointX < -200) {
    pointX = 1000;
  }
  if ((//insectoY + insectoHeight > pointY){
  dist(insectoX + 100, insectoY - 100, pointX + 100, pointY - 100) < 110) && collision == false) {
    scoreL1 = scoreL1 + 1; // Detener el juego
    pointY = random(height);
    pointX = 800; 
    //int pointX = 800;
    collision = true;
  }
  else {
    collision = false;
  }
}

void showScoreL1() {
    // Mostrar el contador enemigos eliminados con la fuente pixeleada
    fill(#7CE8E7);
    textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
    textSize(35);
    text("Score: " + scoreL1 + " Letra new: "+ LetraNew, 5, 33);
}

void screen3(){
  background(0);
  image(movie2, 0, 0, 988, 628);
  float md2 = movie2.duration();
  float mt2 = movie2.time();
  if (mt2 >= 1.7 && press2 == false ) {
   movie2.pause();
   press2 = true;
  }
  if (keyPressed && screen == 3) {
   movie2.play();
  }
  if (mt2 == md2 && press2 == true  ) {
   screen = 4;
  }
}

void screen4(){
  background(0);
  //Imagen del gif para cargarla al fondo
  image(background, 0, 0, 1030,650);
  songL2.play();
   // Dibujar el suelo
  fill(#6F376F);
  rect(0,550,1000,225);  //1.coodenada en x,  2.coordenada en Y, 3.largo, 4.alto de la figura 
  drawAlien(); 
  moveAlien(); 
  drawRobot();
  moveRobot(); 
    // Aumentar la velocidad del robot
  robotSpeed += 0.009;
    // Mostrar el contador de saltos del alien con la fuente pixeleada
  fill(#7CE8E7);
  textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
  textSize(35);
  text("Score: " + scoreL2, 5, 33);
  // Cuando el puntaje llegue a 21 se va a detener el loop del juego
  if (scoreL2 >= 5) {
    songL2.pause(); //Detener la música
    screen = 5;
  } 
}

//Características del alien
void drawAlien() {
  if (isJumping) {
    image(alienJump, alienX, alienY, 200, 200); //Si esta saltando se carga el gif de salto
  } else {
    image(alien, alienX, alienY, 200, 200); //si no esta saltando se carga el gif normal del alien
  }
}

//Movimiento del alien
void moveAlien() {
  if (keyPressed){
    if(keyCode == LEFT) {
      alienX -= 15; 
    } else if(keyCode == RIGHT) {
      alienX += 15;
    }
  }
  if (keyPressed && key == ' ' && !isJumping) {
    alienVelocity = -13; // Hacer que el alien salte
    isJumping = true;
    scoreL2++; // Aumentar el contador de saltos del alien
  }
  if (isJumping) {
    alienY += alienVelocity;
    alienVelocity += gravity;
    if (alienY >= groundLevel) {
      alienY = groundLevel;
      isJumping = false;
    }
  } 
}
//Características del robot
void drawRobot(){
  image(robot, robotX, robotY, 200, 150);
}
//Movimiento del robot
void moveRobot(){
  robotX -= robotSpeed;
    // Si el robot se sale de la pantalla, lo volvemos a colocar al final
  if (robotX < -200) {
    robotX = 1000;
  }
  //Sistema de colisiones
  // Comprobar si el alien choca con el robot
  if (dist(alienX + 100, alienY - 100, robotX + 100, groundLevel - 100) < 110) {
    image(explosion,robotX, robotY, 100,100); //Cargar gif de la explosion
    exploteL2.play(); //cargar sonido de explosion
    fill(#20F5EF);
    textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
    textSize(80); //tamaño de la fuente
    text("GAME OVER", 350, 300); //texto que se muestra en pantalla
    songL2.pause(); //Detener la música
    noLoop(); // Detener el juego
  }
}

void screen5(){
  background(0);
  image(movie3, 0, 0, 988, 628);
  float md3 = movie3.duration();
  float mt3 = movie3.time();
  if (mt3 >= 2 && press3 == false ) {
    movie3.pause();
    press3 = true;
  }
  if (keyPressed && screen == 5) {
    movie3.play();
  }
  if (mt3 == md3 && press3 == true ) {
    screen = 6;
  }
}

void screen6(){
  background(0);
  image(fondo, 0, 0, 988, 628); //Cargamos la imagen de fondo
  songL3.play(); //Ambientamos nuestro nivel 
  dibujar_plataformas();  
  updateLvl3(); 
  displayLvl3();
  onPlatform(); 
  if(score_lvl3 == 5){ //Juego termina, victoria
    noLoop();
    songL3.pause();
    fill(255);
    textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
    textSize(80);
    text("YOU WIN", 350, 300);
    songL3.pause();
    screen = 7;
  }
  else if(health_lvl3 == 0){ //Juego termina, derrota
    noLoop (); 
    fill(255);
    textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
    textSize(80);
    text("GAME OVER", 350, 300);
    songL3.pause();
  }
}
void dibujar_plataformas() { 
    image(platform, ptx1, pty1-anchoP, largoP, anchoP); 
    image(platform, ptx2, pty2-anchoP, largoP, anchoP);
    image(platform, ptx3, pty3-anchoP, largoP, anchoP);
}
   
//Determina que teclas están siendo presionadas   
void keyPressed() {
  switch(keyCode) {
    case RIGHT: right = true; left = false; break;
    case LEFT: left = true; right = false;  break;
    case UP: up = true; break;
  }
}
void keyReleased() {
  switch(keyCode) {
    case RIGHT: right = false; break;
    case LEFT: left = false; break;
    case UP: up = false; break;
  }
}

//Actualiza los valores de las variables
void updateLvl3(){
  if(!enemy){ //Si no existe enemigo, genera uno
      yEnemy = random(10,400); xEnemy = 1000; spdEnemy = random(8, 12); 
      enemy = true;
  }
  if(enemy){ //Mueve al enemigo de izquierda a derecha
    if(xEnemy < 0){ //Si el enemigo sale de pantalla, lo considera inexistente
      enemy = false; xEnemy = 1000; 
    }
    xEnemy -=spdEnemy; 
  }
  if(right){
    if(xP3 < 880){ xP3 += 12; }
    lookR = true; 
  }
  else if(left){
    if(xP3 > -40){ xP3 -= 12; }
    lookR = false;  
  }
  if(up && !isJumping_lvl3){ 
    ySpeed_lvl3 = -12; isJumping_lvl3 = true; 
  }
  if(isJumping_lvl3 ){
    yP3 += ySpeed_lvl3; ySpeed_lvl3 += gravity_lvl3;
    if (yP3 >= limitY ) {
      yP3 = limitY; isJumping_lvl3 = false; 
    }
 }
  if(isFalling){
    yP3 += ySpeed_lvl3; ySpeed_lvl3 +=gravity_lvl3; 
    if(yP3 >= limitY){
      yP3 = limitY; isFalling = false; isJumping_lvl3 = false; 
    }
  }
  if(keyPressed && key == ' '){
    if(lookR){ 
      xBullet = xP3 + 150; yBullet = yP3 + 40; 
      moveBulletR = true; //Indica hacia que lado debe moverse el disparo 
      moveBulletL = false; 
    }
     if(!lookR){
       xBullet = xP3 - 50; yBullet = yP3 + 40; 
       moveBulletL = true; //Indica hacia que lado debe moverse el disparo
       moveBulletR = false; 
     }
  }
  if(moveBulletR){ xBullet += xBulSpeed; }
  if(moveBulletL){ xBullet -= xBulSpeed; }
}
  
void displayLvl3(){
  if(keyPressed && key==' '){ //Animaciones de disparo
      if(lookR){ image(dQR, xP3, yP3, widthP, heightP); } 
      else{ image(dQL,xP3,yP3,widthP, heightP); }     
  }
  else if(right){ //Animaciones de movimiento (derecha)
    if(!isJumping_lvl3 && !isFalling){ image(DWR, xP3, yP3,widthP, heightP); }
    else { 
      if(ySpeed_lvl3 < 0){ image(jumpR, xP3, yP3, widthP, heightP); }
      else { image(fallR, xP3, yP3, widthP, heightP); }
    }
  }
  else if(left){ //Animaciones de movimiento (izquierda)
    if(!isJumping_lvl3 && !isFalling){ image(DWL, xP3, yP3,widthP, heightP); }
    else{
      if(ySpeed_lvl3 < 0){ image(jumpL, xP3, yP3, widthP, heightP); }
      else { image(fallL, xP3, yP3, widthP, heightP); }
    }
  }
  else{ //Jugador sin moviento (izquierda-derecha), se incluye una animación
    if(lookR){
      if(!isJumping_lvl3){ image(DQR, xP3, yP3, widthP, heightP); }
      else if(ySpeed_lvl3 < 0){ image(jumpR, xP3, yP3, widthP, heightP); }
      else{ image(fallR, xP3, yP3, widthP, heightP); }
    }
    else if (!lookR){ 
      if(!isJumping_lvl3){ image(DQL, xP3, yP3, widthP, heightP); }
      else if(ySpeed_lvl3 < 0){ image(jumpL, xP3, yP3, widthP, heightP); }
      else{ image(fallL, xP3, yP3, widthP, heightP); }
    }
  }
  //Animamos el disparo
    image(disp, xBullet, yBullet, 50, 50);
    image(enemyAnimation, xEnemy, yEnemy, 120, 120);  
  //Verificamos colisiones entre disparo y enemigo 
  if((yBullet + 50 > yEnemy && yBullet  < yEnemy + 100 )&& (xBullet+50 > xEnemy && xBullet < xEnemy) && moveBulletR ){
    auxX = xEnemy;auxY = yEnemy; yBullet = -500; xBullet =1100; 
    enemy = false;     
    image(ex,auxX, auxY, 100,100);
    score_lvl3 +=1;
    exploteL3.play();exploteL3.rewind();
  }
 if((yBullet + 50 > yEnemy && yBullet  < yEnemy + 100 )&& (xBullet > xEnemy && xBullet - 50< xEnemy)&&moveBulletL){
    auxX = xEnemy;auxY = yEnemy; yBullet = -500; xBullet =1100; 
    enemy = false;     
    image(ex,auxX, auxY, 100,100);
    score_lvl3 +=1;
    exploteL3.play();exploteL3.rewind();
  }
  //Comprobamos una colisión entre el enemigo y el jugador
  if((xEnemy < xP3 + widthP && xEnemy > xP3 ) && (yEnemy < yP3 + heightP && yEnemy + 100 > yP3)){
    auxX = xEnemy; auxY = yEnemy; 
    enemy = false; 
    image(ex, xP3, yP3, 300,300);
    health_lvl3 -=10; 
    exploteL3.play();
    exploteL3.rewind();
  }
  // Mostrar el contador enemigos eliminados con la fuente pixeleada
  fill(#7CE8E7);
  textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
  textSize(35);
  text("Score: " + score_lvl3, 5, 33);
  //Mostrar el contador de vida con la fuente pixeleada 
  fill(#7CE8E7);
  textFont(pixelFont); //Llamar a la fuente pixeleada y usarla para el texto
  textSize(35);
  text("Health: " + health_lvl3, 5, 66);
}
void onPlatform(){ //Se verifica si el jugador esta sobre plataforma
  if( (xP3 + 50 > ptx3 && xP3 +50 < ptx3 + largoP) && (yP3 + heightP <= pty3 ) ){
    limitY = pty3-heightP;
    //onPlatform = true; 
  }else if((xP3 + 50 > ptx2 && xP3 +50 < ptx2 + largoP) && (yP3 + heightP <= pty2) ){
    isFalling = true; 
    limitY = pty2-heightP; 
    //onPlatform = false; 
  } else if ((xP3 + 50 > ptx1 && xP3 +50 < ptx1 + largoP) && (yP3 + heightP <= pty1 )){
    isFalling = true; 
    limitY = pty1-heightP; 
  }else if(!isJumping_lvl3) {
    limitY = groundlevel_lvl3; 
    isFalling = true; 
  }
}

void screen7(){
  background(0);
  image(creditos, 0, 0, 988, 628);
  creditos.play();
}



void serialEvent(Serial p) {
  while (MiPuerto.available() == 1) {
   Letra = MiPuerto.readChar();
   print(Letra);
  }
  LetraNew = Letra;
}
