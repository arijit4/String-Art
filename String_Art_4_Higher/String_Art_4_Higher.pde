PImage target;
PGraphics result; // image objects for holding the target and result. //<>//
Nail[][] nails; // the grid of nails.
int index_i = 0, index_j = 0; // the starting index.

// The below parametres can be editted by the owner.
float distBetweenNails = 5; // distance between each nail from others.
int leftRight = 4; // will look for 4 nails left and 4 nails right from the current nail for best result. 
int topBottom = 4; // will look for 4 nails up and 4 nails down from the current nail for best result.
color boardColor = color(0, 0, 0); // default board color, Black
color threadColor = color(255, 255, 255); // default thread color, White
float stringLength = 314159; // default stirng length, pi*10e5
float currentLength = 0;
String targetName = "blurred"; // the target image name to perform the oparations on.

Upscaler upscaler;

void setup() {
  size(500, 500); // as the target image should be 500x500
  //hint(DISABLE_ASYNC_SAVEFRAME);
  upscaler = new Upscaler(10); // upscales the image by 10x

  target = loadImage(targetName + ".jpg"); // importing the target image
  result = createGraphics(target.width, target.height); // crating the result image resembling to the target image.

  nails = new Nail[(int) (target.width/distBetweenNails) + 1][(int) (target.height/distBetweenNails) + 1];
  // crating a grid of nails keeping respect to the distance between each nail.

  for (int i = 0; i <= target.width; i += distBetweenNails) {
    for (float j = 0; j <= target.height; j += distBetweenNails) {
      nails[(int) (i / distBetweenNails)][(int) (j / distBetweenNails)] = new Nail(i, j);
      // assigning nails as the members of the 'nails' grid
      nails[(int) (i / distBetweenNails)][(int) (j / distBetweenNails)].addPath(new Nail(i, j));
      // assigning itself to it's paths to prevent recursion on the same nail.
    }
  }
  // the program starts from the middle of the canvas
  index_i = nails.length / 2;
  index_j = nails[0].length / 2;

  // filling each pixel of the result image with the boardColor.
  upscaler.background(0);
  /*result.loadPixels();
  for (int i = 0; i < result.pixels.length; i++) {
    result.pixels[i] = color(boardColor, 255);
  }
  result.updatePixels();*/
  
  image(target, 0, 0); // shows an preview of the target.
  
  stroke(threadColor, 100);
  
  result.beginDraw();
  result.background(0);
  result.stroke(threadColor, 100);
  result.endDraw();
  
  upscaler.stroke(threadColor, 100);
  
  strokeWeight(1);
  upscaler.strokeWeight(1);
}

void draw() {
  // assigning false value to overcome misfortuned crashes.
  int best_i = index_i, best_j = index_j;
  float bestScore = 0;

  for (int i = max(0, index_i - topBottom); i <= min(index_i + topBottom, nails.length - 1); i++) {
    // if 'index_i - topBottom' is negative, it automatically fixes that to 0.
    for (int j = max(0, index_j - leftRight); j <= min(index_j + leftRight, nails[0].length - 1); j++) {
      // if 'index_j - leftRight' is negative, it automatically fixes that to 0.
      if (nails[index_i][index_j].notUsedYet(nails[i][j])) {
        // undo the oparation from the previous iteration.
        image(result.get(), 0, 0);

        Nail tmp = nails[index_i][index_j];
        Nail tmp2 = nails[i][j];
        line(tmp.x, tmp.y, tmp2.x, tmp2.y);
        
        
        target.loadPixels();
        loadPixels();

        float score = calculateScore(target.pixels, pixels);
        if (score >= bestScore) { // if the score for the current move exceeds the cureent best,
          bestScore = score; // update the bestScore with score,
          best_i = i; // best_i with i and
          best_j = j; // best_j with j.
        }
        updatePixels();
        target.updatePixels();
      }
    }
  }
  // undo the move from the last iteration
  image(result, 0, 0);

  // add the path to the current nail, so it never creates the same path.
  nails[index_i][index_j].addPath(nails[best_i][best_j]);

  Nail tmp = nails[index_i][index_j];
  Nail tmp2 = nails[best_i][best_j];
  line(tmp.x, tmp.y, tmp2.x, tmp2.y); // finally draw the nail between current nail and the best nail
  upscaler.line(tmp.x, tmp.y, tmp2.x, tmp2.y);
  
  result.beginDraw();
  result.line(tmp.x, tmp.y, tmp2.x, tmp2.y);
  result.endDraw();
  // stringLength shortens by the distance between those 2 nails.
  currentLength += dist(tmp.x, tmp.y, tmp2.x, tmp2.y);

  //println(index_i + " " + index_j + "\t" + best_i + " " + best_j);
  //println(stringLength);

  index_i = best_i; // the current index_i is best_i
  index_j = best_j; // the current index_j is best_j

  // update the result with the current oparations.
  /*result.loadPixels();
  loadPixels();
  for (int i = 0; i < result.pixels.length; i++) {
    result.pixels[i] = pixels[i];
  }
  result.updatePixels();
  updatePixels();*/

  if (currentLength >= stringLength) { // if the string is over,
    // save the image
    result.get().save(/*sketchPath() + "\\exported\\" + */targetName + "-String_Art_SL-PI.jpg");
    upscaler.export(/*sketchPath() + "\\exported\\" + */currentLength + "-10x.jpg");
    // and never loop again. 
    noLoop();
  }
}

float calculateScore(int[] arr1, int[] arr2) {
  float score = 0;
  for (int i = 0; i < arr1.length; i++) {
    score += abs(brightness(arr1[i]) - brightness(arr2[i]));
  }
  return 1/score;
}

PImage updateImage(PImage img) {
  PImage res = new PImage(img.width, img.height);
  res.loadPixels();
  img.loadPixels();
  for (int i = 0; i < res.pixels.length; i++) {
    res.pixels[i] = color(round(brightness(img.pixels[i])/127) * 127);
  }
  res.updatePixels();
  img.updatePixels();

  return res;
}

void mouseClicked() {
  //println(sketchPath());
  result.get().save(/*sketchPath() + "\\exported\\" + targetName + "-String_Art-" + */currentLength + ".jpg");
}

void keyPressed() {
  if (key == 's') {
    upscaler.export(/*sketchPath() + "\\exported\\" + */currentLength + "-10x.jpg");
  }
}
