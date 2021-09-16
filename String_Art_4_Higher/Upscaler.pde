class Upscaler {
  PGraphics upscaled;
  float upscaleRatio = 1;

  Upscaler(int w, int h) {
    this.upscaled = createGraphics(w, h);
    this.upscaleRatio = w/width;
  }

  Upscaler(float ratio) {
    this.upscaleRatio = ratio;
    this.upscaled = createGraphics((int) ratio * width, (int) ratio * height);
  }
  
  void background(float col) {
    this.upscaled.beginDraw();
    this.upscaled.background(col);
    this.upscaled.endDraw();
  }

  void stroke(color x, float opacity) {
    this.upscaled.beginDraw();
    this.upscaled.stroke(x, opacity);
    this.upscaled.endDraw();
  }

  void strokeWeight(float x) {
    this.upscaled.beginDraw();
    this.upscaled.strokeWeight(x * upscaleRatio);
    this.upscaled.endDraw();
  }

  void line(float x1, float y1, float x2, float y2) {
    this.upscaled.beginDraw();
    x1 *= upscaleRatio;
    y1 *= upscaleRatio;
    x2 *= upscaleRatio;
    y2 *= upscaleRatio;

    this.upscaled.line(x1, y1, x2, y2);
    
    this.upscaled.endDraw();
  }

  void export(String filename) {
    //this.upscaled.endDraw();
    PImage tmp = this.upscaled.get();
    tmp.save(filename/* + ".jpg"*/);
  }
}
