final float p = 0.2;
final float q = 1-p;
boolean saut = false;
long pause = 0;
int n = 1; // nombre de personnes qui ont partagé
ArrayList<Point> listeDesPoints;
int it = 0;

void setup(){
  size(850, 850);
  textSize(30);
  listeDesPoints = new ArrayList<Point>();
}

void draw(){
  float proba_jump = 0;
  // Conditions de saut

  if (saut == false){ // état 0
    proba_jump = p;
    saut = randomJump(proba_jump);
    System.out.println("false");
  }
  else { // état 1
    proba_jump = q;
    saut = randomJump(proba_jump);
    System.out.println("true");
  }
  // Affichages
  System.out.println(n);
  fill(204); // couleur rect = bckg
  stroke(204); // borders rect = bckg
  rect(width - 110, 0, 100, 30); // place un rectange pour cacher le n-1
  fill(255); // couleur d'écriture
  text(n, width - 100, 30); // affichage de n
}

// Algorithme
boolean randomJump(float proba_saut) {
  boolean jump = false;
  float rand = random(0, 1);
  int x = (int) random(width / 2 - n, width / 2  + n ); 
  int y = (int) random(height / 2 - n, height / 2 + n);
  System.out.println(rand);

  if (rand <= proba_saut) { // saut à l'état n+1 donc saut
  // + p est grand + le if sera utilisé
    jump = true;
    /* on place les cibles infectées par les fake news au centre
       du canvas puis on augmente le périmètre de propagation à 
       chaque itération */
    
    listeDesPoints.add(new Point(x,y,p,true));
    n += 5; // augmentation de la propagation
    pause = 0; // saut donc pas d'attente : le partage est instantanné
  }
  else { // reste à l'état n donc pas de saut
    jump = false;
    listeDesPoints.add(new Point(x,y,p,false));
    pause = 100; // on marque une pause pour différencier les partages et les non partages
  }
  try { 
    Thread.sleep(pause); // marque une pause lorsqu'il n'y a pas de saut
  } catch(InterruptedException e){ e.printStackTrace(); }
  
  return jump; // retourne true si saut sinon false
} 


public class Point {
  public int x;
  public int y;
  public boolean isInfected;
  public float proba;
  public float tailleDuReseau;
  public ArrayList<PointReseau> reseau;
  
  public Point(float proba) {
     this.proba = proba;
     this.isInfected = false;
  }
  
  public Point(int x, int y, float proba, boolean infected){
    this.x = x;
    this.y = y;
    this.isInfected = infected;
    this.proba = proba;
    reseau = new ArrayList();
    this.tailleDuReseau = random(10, 100);
    
    
    if (infected) {
      //tailleDuReseau = analyseDuReseau();
      remplirReseau(x,y,proba);
      stroke(255,0,0); // rouge 
      fill(255,0,0);
      ellipse(x,y,5,5);
    } 
    else {
      stroke(255); // rouge contour blanc
      ellipse(x,y,5,5);
    }
  }
 
  public float analyseDuReseau() {
    float tailleDuReseau = 5;
    for (Point p : listeDesPoints) {
       if ((this.x >= p.x - 20 || this.x <= p.x + 20) && (this.y >= p.y - 20 || this.y <= p.y + 20)) {
           tailleDuReseau += 0.1;
       }
    }
    return tailleDuReseau;
  }
 
  public void remplirReseau(int x, int y, float proba_saut) {
    float rand = 0;
     for (int i = 0; i < this.tailleDuReseau; i++) {
         rand = random(0, 1);
         int zoneX = (int) random(x - 20, x + 20);
         int zoneY = (int) random(y - 20, y + 20);
         
         if (rand <= proba_saut) { 
          this.reseau.add(new PointReseau(zoneX,zoneY,proba_saut + 0.5,true)); // TEST
          
          pause = 0;
        }
        else { 
          this.reseau.add(new PointReseau(zoneX,zoneY,proba_saut,false));
          pause = 0; // on marque une pause pour différencier les partages et les non partages
        }
        try { 
          Thread.sleep(pause); // marque une pause lorsqu'il n'y a pas de saut
        } catch(InterruptedException e){ e.printStackTrace(); }
     }
  }
 }
 
 public class PointReseau {
  public int x;
  public int y;
  public boolean isInfected;
  public float proba;
  
  public PointReseau(float proba) {
     this.proba = proba;
     this.isInfected = false;
  }
  
  public PointReseau(int x, int y, float proba, boolean infected){
    this.x = x;
    this.y = y;
    this.isInfected = infected;
    this.proba = proba;
    if (infected) { // personnes du réseau ont RT
      stroke(255,0,0);
      fill(255,0,0);
      ellipse(zoneX(x),zoneY(y),5,5);
    } 
    else { // personnes du réseau qui n'ont pas RT
      stroke(255);// rouge contour blanc
      //fill(255);
      ellipse(zoneX(x),zoneY(y),5,5);
    }
    
    try { 
      Thread.sleep(5); // marque une pause lorsqu'il n'y a pas de saut
    } catch(InterruptedException e){ e.printStackTrace(); }
  }
  
    public int zoneX(int x) {
      return (int) random(x - 20, x + 20);
    }
    public int zoneY(int y) {
      return (int) random(y - 20, y + 20);
    }
 }
