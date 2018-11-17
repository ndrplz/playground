/* 
Interact with a simple Perlin-noise-based 3D terrain 
See: https://thecodingtrain.com/CodingChallenges/011-perlinnoiseterrain.html
*/
int cols, rows;
int grid_density = 30; 
int grid_w = 4000;
int grid_h = 4000;
float fly_x = 0;
float fly_y = 0;
float noise_step = 0.1;

float[][] terrain;

void setup(){
  size(1200, 700, P3D);
  
  strokeWeight(1);
  stroke(200,140,40);
  noFill();  
  
  frameRate(30);
  
  cols = grid_w / grid_density;
  rows = grid_h / grid_density;
  terrain = new float[cols][rows];
}

void draw(){
  background(0);

  // Camera angle
  float alpha_view = radians(70);
  
  // Shift perlin noise (i.e. terrain) by mouse-controlled offset
  float alpha_fly_x = map(mouseX, 0, width, PI, 0);
  float alpha_fly_y = map(mouseY, 0, height, PI, 0);
  float scale_f = 0.2;
  fly_x += cos(alpha_fly_x) * scale_f;
  fly_y += cos(alpha_fly_y) * scale_f;
  
  float yoff = fly_y;
  for(int y=0; y < rows; y++){
    float xoff = fly_x;
    for (int x = 0; x < cols; x++){
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -150, 150);
      xoff += noise_step;
    }
    yoff += noise_step;
  }
  
  // Adjust things to fit on camera
  translate(width/2, height/2); 
  rotateX(alpha_view);
  translate(-grid_w/2, -grid_h/2);
  
  // Draw mesh
  for(int y=0; y < rows-1; y++){
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++){
      vertex(x*grid_density, y*grid_density, terrain[x][y]);
      vertex(x*grid_density, (y+1)*grid_density, terrain[x][y+1]);
    }
    endShape();
  }
  //saveFrame();
}
