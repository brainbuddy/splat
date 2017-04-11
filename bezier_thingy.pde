float cx=250;
float cy=150;
boolean unClicked = true;
int clicked = -1;

Thing A;

void setup() {
  size(500,300);

  A = new Thing(7);
}

void draw() {
   background(215,230,255);
   stroke(150);
   
   if(mousePressed && unClicked) {
       clicked = findClicked(A, mouseX, mouseY);
   }
   
   if(mousePressed) {
     A.Drag(clicked, mouseX, mouseY);
   }
   
   A.Move();
   A.Draw();
   
}


class Thing {
  PVector[] c;
  PVector[] p;
  float theta;
  
  Thing(int N) {
    
    theta = 0;
    
    c = new PVector[N];
    p = new PVector[N];

    for(int n=0; n<c.length; n++) {
      c[n] = new PVector(cx+20*cos(2*PI/N*n),cy+20*sin(2*PI/N*n));
    }
    
    for(int n=0; n<p.length; n++) {
      p[n] = new PVector(cx+70*cos(2*PI/N*n),cy+70*sin(2*PI/N*n));
    }
    
  }
  
  
  void Move() {
    
    //cx = cx + 0.2*randomGaussian();
    //cy = cy + 0.2*randomGaussian();
    
    int N = c.length;
    
    PVector F = new PVector(0,0);
    
    for(int n=0; n<p.length; n++) {
      F.set(F.x + (p[n].x-cx),  F.y + (p[n].y-cy) );
    }
    
    F.set(F.x/p.length, F.y/p.length);
    
    
    float T = 0;
    
    for(int n=0; n<p.length; n++) {
      float theta1 = atan2(c[n].y-cy, c[n].x-cx);
      float theta2 = atan2(p[n].y-cy, p[n].x-cx);
      
      float dtheta = theta2-theta1;
      
      if(abs(dtheta)>=PI) {
       
        if(dtheta<0) {
          dtheta = 2*PI+dtheta;
        } else {
          dtheta = dtheta-2*PI;
        }
        
      }
      
      T = T + 0.5*dtheta;
    }
    
    cx = cx + 0.5*F.x;
    cy = cy + 0.5*F.y;
     
    theta = theta + 0.2*T;
    
    for(int n=0; n<c.length; n++) {
      float R = sqrt( pow(p[n].x-cx,2) + pow(p[n].y-cy,2));
      
      c[n].set(cx+(5 + R/5.0)*cos(2*PI/N*n + theta),cy+(5 + R/5.0)*sin(2*PI/N*n + theta));
    }
    
  }
  
  
  void Drag(int i, float x, float y) {
    
    if(i==-10) {
      DragThing(x,y);
      return;
    } else if(i==-15) {
      DragBody(x,y);
      return;
    }
    
    if(i<0) { return; }
    
    p[i].x = x;
    p[i].y = y;
  }
  
  void DragThing(float x, float y) {
    
    float dX = x-cx;
    float dY = y-cy;
    
    cx = cx + dX; cy = cy + dY;
    
    for(int n=0; n<p.length; n++) {
     
      p[n].set(p[n].x+dX, p[n].y+dY);
      c[n].set(c[n].x+dX, c[n].y+dY);
      
    }
    
  }
  
  void DragBody(float x, float y) {
    
    float dX = x-cx;
    float dY = y-cy;
    
    cx = cx + dX; cy = cy + dY;
    
    for(int n=0; n<p.length; n++) {
     
      c[n].set(c[n].x+dX, c[n].y+dY);
      
    }
    
  }
  
  void Draw() {
    
    Splat();
    
    //Skeleton();
    
  }
  
  void Skeleton() {
    for(int n=0; n<c.length; n++) {
       int m = (n+1) % (c.length);
       
       strokeWeight(1); stroke(192);
       line(c[n].x,c[n].y,c[m].x, c[m].y);
       line(c[n].x,c[n].y,p[n].x, p[n].y);
    }
    
    
    for(int n=0; n<p.length; n++) {
       strokeWeight(6); stroke(0);
       point(c[n].x, c[n].y);
       
       stroke(200,0,0);
       point(p[n].x, p[n].y);
    }
  }
  
  
  
  void Splat() {
  
    noStroke(); fill(0,0,255); 
    strokeWeight(2); stroke(0);
    
      float LL = 5;
      
      beginShape();
      
      for(int m=0; m<p.length; m++) {
          
          int n = (m+1) % p.length;
          int o = (n+1) % p.length;
        
          PVector v = new PVector(p[n].x-c[n].x,p[n].y-c[n].y);
          float R = v.mag();
          PVector vp = v.copy();
          vp.rotate(PI/2);
          vp.setMag(1);
          
          
          vertex((c[m].x+c[n].x)/2.0, (c[m].y+c[n].y)/2.0);
          
          bezierVertex(c[n].x,c[n].y,     p[n].x-0.5*v.x-LL*vp.x,p[n].y-0.5*v.y-LL*vp.y,     p[n].x-0.35*v.x-LL*vp.x, p[n].y-0.35*v.y-LL*vp.y);
          bezierVertex(p[n].x-0.35*v.x-LL*vp.x, p[n].y-0.35*v.y-LL*vp.y,    p[n].x-2*LL*vp.x, p[n].y-2*LL*vp.y, p[n].x, p[n].y);
          
          bezierVertex(p[n].x+2*LL*vp.x,p[n].y+2*LL*vp.y, p[n].x-0.2*v.x+LL*vp.x,p[n].y-0.2*v.y+LL*vp.y,p[n].x-0.35*v.x+LL*vp.x,p[n].y-0.35*v.y+LL*vp.y);
          bezierVertex(p[n].x-0.5*v.x+LL*vp.x,p[n].y-0.5*v.y+LL*vp.y,   c[n].x, c[n].y, (c[n].x+c[o].x)/2.0, (c[n].y+c[o].y)/2.0); 
        
    }
    
    endShape();
  }
  
}





void mouseReleased() {
   unClicked = true; 
}


int findClicked(Thing A, float X, float Y) {
  unClicked = false;
  
  float min_dist2 = pow(40,2);
  int winner = -1;
  
  float dist2 = pow(X-cx,2) + pow(Y-cy,2);
  
  if(dist2 < pow(50,2)) {
    if(mouseButton == RIGHT) {
      return -10;
    } else {
      return -15;
    }
  }
  
  for(int n=0; n<A.p.length; n++) {
    dist2 = pow(A.p[n].x-X,2) + pow(A.p[n].y-Y,2);
    
    if( dist2<min_dist2) {
      min_dist2 = dist2;
      winner = n;
    }
  }
  
  return winner;
}