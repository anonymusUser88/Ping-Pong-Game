/*
  Sethumi Hapuarachchi
  November 13, 2023
  ICS 3U1
  This is a program that creates a game of pong
*/

// paddle position variables
int leftPaddleXPosition = 70;
int rightPaddleXPosition = 940;
int leftPaddleYPosition = 350;
int rightPaddleYPosition = 350;

// moving the paddle variables. At the moment they are all false since the paddles aren't moving
boolean rightPaddleUp = false;
boolean rightPaddleDown = false;
boolean leftPaddleUp = false;
boolean leftPaddleDown = false;

// drawing and moving the ball variables
int ballXPosition = 500;
int ballYPosition = 350;
int ballXSpeed = 5;
int ballYSpeed = 2;

// point variables
int playerOnePoints = 0; // player on the left
int playerTwoPoints = 0; // player on the right

// other variables
PFont myFont; // to create a custom font
boolean gameStarted = false; // helps with transitioning between menu and game screen
boolean onePlayerMode = false; // whether you do


// main methods
void setup() // helps with settig up basic things
{
  size(1000, 700);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  // this code is from the processing website in order to import a new font
  String[] fontList = PFont.list(); // this is not being used in the game, but it imports the fonts
  myFont = createFont("Ebrima", 32);
  textFont(myFont);
}

void draw() // runs the whole game
{
  if (!gameStarted) // if the game has not started yet
  {
    drawMenuScreen(); // draws the menu screen
  } 
  else // if the player clicked the button and the game started
  {
    if (playerOnePoints >= 10 || playerTwoPoints >= 10) // if one of the players has 10 points
    {
      endGameScreen(); // the end game screen is generated
    } 
    else // if the game is still being played
    {
      generateBackground(); // generates the background
      drawPaddles(); // draws still images of paddles
      moveLeftPaddle(); // helps with moving the left paddle, only the player can move it
      moveRightPaddle(); // helps with moving the right paddle, in one player, the computer players, in two player, a person controls it 
      moveBall(); // animates the ball with variables and the drawBall() method
      checkIfBallHitsEdges(); // checks whether the ball hits the edges
      checkIfBallHitsLeftPaddle(); // checks if the ball hits the left paddle
      checkIfBallHitsRightPaddle(); // checks if the ball hits the right paddle
      displayPoints(); // prints and updates points on screen
    }
  }
}

void keyPressed() // For the movement of the paddles. If a key is being pressed, then it says that a particular movement is being done
{
  // left paddle
  if (keyCode == 87 || keyCode == 119) // for example, if the w key is pressed... (there are 2 values to account for whether the letter is upper case or lower case)
  {
    leftPaddleUp = true; // then it says that the left paddle is going up. This concept is applied everywhere else
  } 
  else if (keyCode == 83 || keyCode == 115) // s key
  {
    leftPaddleDown = true;
  }

  // right paddle
  if (!onePlayerMode) // will only happen if it's in two player mode, ensures the computer cannot be sabatoged
  {
    if (keyCode == 38) // up arrow
    {
      rightPaddleUp = true;
    } 
    else if (keyCode == 40) // down arrow
    {
      rightPaddleDown = true;
    }
  }
}

void keyReleased() // This same concept is applied here, except it changes the values back to false when the key is released
{
  // left paddle
  if (keyCode == 87 || keyCode == 119) // for example, when the w key is no longer pressed...
  {
    leftPaddleUp = false; // it identifies that the left paddle should no longer be pressed
  } 
  else if (keyCode == 83 || keyCode == 115)
  {
    leftPaddleDown = false;
  }

  // right paddle
  if (keyCode == 38)
  {
    rightPaddleUp = false;
  } 
  else if (keyCode == 40)
  {
    rightPaddleDown = false;
  }
}

void mousePressed() // for checking whether a button is being clicked
{
  // dummy variables for one player button
  boolean pastLeftOfOnePlayerButton = mouseX > 200;
  boolean pastRightOfOnePlayerButton = mouseX < 400;
  boolean pastTopOfOnePlayerButton = mouseY > 500;
  boolean pastBottomOfOnePlayerButton = mouseY < 700;

  if (pastLeftOfOnePlayerButton && pastRightOfOnePlayerButton && pastTopOfOnePlayerButton && pastBottomOfOnePlayerButton) // if the player is clicking the button
  {
    gameStarted = true;
    onePlayerMode = true; // identifies that it's one player mode
  }

  // dummy variables for two player button
  boolean pastLeftOfTwoPlayerButton = mouseX > 600;
  boolean pastRightOfTwoPlayerButton = mouseX < 800;
  boolean pastTopOfTwoPlayerButton = mouseY > 500;
  boolean pastBottomOfTwoPlayerButton = mouseY < 700;

  if (pastLeftOfTwoPlayerButton && pastRightOfTwoPlayerButton && pastTopOfTwoPlayerButton && pastBottomOfTwoPlayerButton) // if the player is clicking the button
  {
    gameStarted = true;
  }
}

// paddle methods
void drawPaddles()
{
  // left paddle
  stroke(#fb3463);
  fill(#fb3463);
  rect(leftPaddleXPosition, leftPaddleYPosition, 40, 100);

  // right paddle
  stroke(#333434);
  fill(#333434);
  rect(rightPaddleXPosition, rightPaddleYPosition, 40, 100);
}

void moveLeftPaddle()
{
  // checks if the user is making the paddle move
  if (leftPaddleUp)
  {
    leftPaddleYPosition-=5;
  }
  if (leftPaddleDown)
  {
    leftPaddleYPosition+=5;
  }

  // checks if the paddle hits the edges
  if (leftPaddleYPosition < 50) // if it hits the top
  {
    leftPaddleYPosition+=5;
  } 
  else if (leftPaddleYPosition > 650) // if it hits the bottom
  {
    leftPaddleYPosition-=5;
  }
}

void moveRightPaddle()
{
  if (onePlayerMode) // if it is one player mode
  {
    if (ballXPosition >= 550) // first the paddle only moves if the ball x position is greater than or equal to 500
    {
      if (ballYPosition >= rightPaddleYPosition) // if the ball is below the paddle
      {
        rightPaddleUp = false;
        rightPaddleDown = true;
      } 
      else // if the ball is above the paddle
      {
        rightPaddleDown = false;
        rightPaddleUp = true;
      }
    }
  }

  // making the paddle move
  if (rightPaddleUp) // first it checks if the condition is true (i.e. is the right paddle going up?)
  {
    rightPaddleYPosition-=5; // and then it changes the position of the paddle accordingly
  }
  if (rightPaddleDown)
  {
    rightPaddleYPosition+=5;
  }

  // checks if it hits the edges
  if (rightPaddleYPosition < 50) // if it hits the top
  {
    rightPaddleYPosition+=5;
  } 
  else if (rightPaddleYPosition > 650) // if it hits the bottom
  {
    rightPaddleYPosition-=5;
  }
}

// ball methods
void drawBall() // draws the still image of the ball
{
  fill(#fffecd);
  stroke(#fffecd);
  ellipse(ballXPosition, ballYPosition, 20, 20);
}

void moveBall()
{
  drawBall();
  ballXPosition+=ballXSpeed; // the x position changes based on the value of ballXSpeed. If ballXSpeed is positive, then it will move to the right. Otherwise it moves to the left
  ballYPosition+=ballYSpeed; // the same concept applies to the y position
}

void checkIfBallHitsEdges()
{
  // checks if it hits the walls
  if (ballXPosition <= 0 || ballXPosition >= 1000) // the left and right walls
  {
    if (ballXPosition <= 0) // a condition that checks who to give points to
    {
      playerTwoPoints++; // if it hit the left wall, player 2 gets a point
    } 
    else
    {
      playerOnePoints++; // if it hit the right wall, player one gets a point
    }
    
    ballXSpeed = -ballXSpeed;
    // returning the ball to its original position; it then starts moving right away
    ballXPosition = 500;
    ballYPosition = 350;
  }
  if (ballYPosition <= 0 || ballYPosition >= 700) // if the ball touches the top and bottom walls
  {
    ballYSpeed = -ballYSpeed;
  }
}

void checkIfBallHitsLeftPaddle()
{
  // dummy variables
  boolean ballPastLeftOfPaddle = ballXPosition >= leftPaddleXPosition - 25;
  boolean ballPastRightOfPaddle = ballXPosition <= leftPaddleXPosition + 25;
  boolean ballPastTopOfPaddle = ballYPosition >= leftPaddleYPosition - 55;
  boolean ballPastBottomOfPaddle = ballYPosition <= leftPaddleYPosition + 55;

  // checks if it hits paddle
  if (ballPastLeftOfPaddle && ballPastRightOfPaddle && ballPastTopOfPaddle && ballPastBottomOfPaddle)
  {
    ballXSpeed = abs(ballXSpeed); // this makes the ball go to the right. I had to use the abs function so it doesn't get stuck in the paddle. I got this code from Mr. P
  }
}

void checkIfBallHitsRightPaddle()
{
  // dummy variables
  boolean ballPastLeftOfPaddle = ballXPosition >= rightPaddleXPosition - 25;
  boolean ballPastRightOfPaddle = ballXPosition <= rightPaddleXPosition + 25;
  boolean ballPastTopOfPaddle = ballYPosition >= rightPaddleYPosition - 55;
  boolean ballPastBottomOfPaddle = ballYPosition <= rightPaddleYPosition + 55;

  // checks if it hits paddle
  if (ballPastLeftOfPaddle && ballPastRightOfPaddle && ballPastTopOfPaddle && ballPastBottomOfPaddle)
  {
    ballXSpeed = -abs(ballXSpeed); // this makes the ball go to the left. I had to use the abs function so it doesn't get stuck in the paddle. I got this code from Mr. P
  }
}

// other methods
void drawMenuScreen()
{
  background(#66cdcc);
  textSize(100);
  fill(#fffedc);
  stroke(#fffedc);
  text("Ping Pong", 500, 100);
  
  // Extra details
  circle(200, 125, 40);
  circle(800, 125, 40);
  circle(50, 350, 20);
  circle(950, 350, 20);
  line(50, 50, 50, 300);
  line(50, 400, 50, 650);
  line(950, 50, 950, 300);
  line(950, 400, 950, 650);
  line(50, 25, 950, 25);
  line(50, 675, 950, 675);
  
  // text
  textSize(50);
  text("How to play", 500, 200);
  strokeWeight(5);
  line(350, 250, 650, 250);
  textSize(25);
  text("You can play againt the computer or with another person", 500, 300);
  text("The left paddle moves with W and S keys", 500, 350);
  text("In one player, the right paddle is the computer", 500, 400);
  text("In two player, the right paddle moves with the up and down arrows", 500, 450);
  text("The first player to reach 10 points wins!", 500, 500);

  // one player button
  fill(#66cdcc);
  rect(300, 600, 200, 100);
  textSize(35);
  fill(#fffedc);
  text("One Player", 300, 590);

  // two player button
  fill(#66cdcc);
  rect(700, 600, 200, 100);
  textSize(35);
  fill(#fffedc);
  text("Two Player", 700, 590);
  
  // green border
  stroke(#162d4c);
  strokeWeight(10);
  line(0, 0, 1000, 0);
  line(1000, 0, 1000, 700);
  line(1000, 700, 0, 700);
  line(0, 1000, 0, 0);
}

void generateBackground()
{
  background(#66cdcc);
  // green border
  stroke(#162d4c);
  strokeWeight(10);
  line(0, 0, 1000, 0);
  line(1000, 0, 1000, 700);
  line(1000, 700, 0, 700);
  line(0, 1000, 0, 0);

  // creating the dotted line in the middle
  strokeWeight(1);
  int j = 0;
  for (int i = 0; i < 15; i++)
  {
    line(500, 60*j, 500, 60*(j+0.5));
    j+=1;
  }
}

void displayPoints()
{
  textSize(15);
  text(playerOnePoints, 50, 50); // these commands print the scores
  text(playerTwoPoints, 950, 50);
}

void endGameScreen()
{
  background(#66cdcc);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  // green border
  stroke(#162d4c);
  strokeWeight(10);
  line(0, 0, 1000, 0);
  line(1000, 0, 1000, 700);
  line(1000, 700, 0, 700);
  line(0, 1000, 0, 0);

  // yellow details
  fill(#fffedc);
  stroke(#fffedc);
  rect(500, 200, 900, 200);
  drawSun(200, 500);
  drawSun(800, 500);
  drawTrophy(400, 350);

  //text
  textAlign(CENTER, CENTER);
  textSize(125);
  fill(#162d4c);
  text("Player 1 wins!", 500, 200);
}

void drawTrophy(int xPos, int yPos) // one of the elements in the game over screen, origin: top left corner
{
  rectMode(CORNER);

  fill(#fffedc);
  noStroke();
  rect(xPos, yPos, 200, 100);
  rect(xPos + 25, yPos, 150, 150);
  rect(xPos + 75, yPos + 100, 50, 100);
  rect(xPos + 25, yPos + 225, 150, 75);
  fill(#f5c264);
  rect(xPos, yPos + 25, 200, 50);
  rect(xPos + 25, yPos + 110, 150, 25);
  rect(xPos + 25, yPos + 200, 150, 25);
  fill(#fffedc);
  textSize(40);
  text("#1", xPos + 100, yPos + 40);
}

void drawSun(int xPos, int yPos) // the sun shape, origin: center of circle
{
  // x = 200, y = 500
  circle(xPos, yPos, 100);
  line(xPos, yPos - 150, xPos, yPos - 75);
  line(xPos, yPos + 75, xPos, yPos + 150);
  line(xPos + 75, yPos, xPos + 150, yPos);
  line(xPos - 150, yPos, xPos - 75, yPos);
  line(xPos - 125, yPos - 150, xPos - 50, yPos - 50);
  line(xPos + 50, yPos - 50, xPos + 125, yPos - 150);
  line(xPos - 125, yPos + 150, xPos - 50, yPos + 50);
  line(xPos + 50, yPos + 50, xPos + 125, yPos + 150);
}
