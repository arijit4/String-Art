# String Art with pins

This project is made to produce high resolution [`String-Art`](https://en.wikipedia.org/wiki/String_art) with just a few steps.
1. Copy your desired image to the home diretory of the code.
2. Rename your image to `blurred.jpg` or edit the value of the variable `targetName` to `yourImageName` (without extension) in `String_Art_4_Higher.pde`.
3. If the extension is not `jpeg` (`.jpeg` or `.png`), please rename the extension part in the code in `String_Art_4_Higher.pde` (line 23).
4. Run the code and wait for it to generate the string art image.
5. Enjoy!

# Sample
![Sample image]("https://github.com/arijit4/String-Art/blob/master/String_Art_4_Higher/exported/Me-String_Art_SL-PI.jpg?raw=true")

# File descriptions
- `exported` : Stores every generated images in the end of each generation.
- `Nail.pde` : Stores the properties of each nails on the board.
- `String_Art_4_Higher.pde` : Launches the main program and mangages everything.
- `Upscaler.pde` : Generates high-res image with same calculations to make the image crisp.
