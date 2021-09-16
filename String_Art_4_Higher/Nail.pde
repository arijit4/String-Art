class Nail {
  float x, y;
  ArrayList<Nail> pathMade;
  
  Nail(float x, float y) {
    this.x = x;
    this.y = y;
    pathMade = new ArrayList<Nail>();
  }
  
  void update(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void show(float diametre) {
    ellipse(x, y, diametre, diametre);
  }
  
  boolean notUsedYet(Nail n) {
    for (int i = 0; i < pathMade.size(); i++) {
      if (dist(n.x, n.y, pathMade.get(i).x, pathMade.get(i).y) <= 1) {
        return false; // this path has been created before
      }
    }
    
    return true; // this path is left to explore.
  }
  
  void addPath(Nail n) {
    this.pathMade.add(n); // assigning the path to its registry.
  }
}
