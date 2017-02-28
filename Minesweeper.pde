

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int totalBombs = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); 

void setup ()
{
    size(600,600);
    textAlign(CENTER,CENTER);
    textSize(14);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0 ; row < NUM_ROWS ; row++)
      for(int col = 0 ; col < NUM_COLS ; col++)
        buttons[row][col] = new MSButton(row,col);
    
    for(int i = 0 ; i < totalBombs; i++)
    setBombs();
}
public void setBombs()
{
    //your code
    int r = (int)(Math.random()*NUM_ROWS) ;
    int c = (int)(Math.random()*NUM_COLS) ;
    //System.out.println( "(" + r + ", " + c + ")");
    if(!(bombs.contains(buttons[r][c])))
        bombs.add(buttons[r][c]);
    else if(bombs.contains(buttons[r][c])) //in case more than one bomb is generated on the same spot; make another bomb
        setBombs(); 
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int count = 0;
    for(int r = 0; r<NUM_ROWS; r++)
        for(int c = 0 ; c<NUM_COLS; c++)
            if(!bombs.contains(buttons[r][c]))
                if(buttons[r][c].isClicked())
                    count++;

    if(count == NUM_ROWS*NUM_COLS - totalBombs)
        return true;
    else
        return false;
}
public void displayLosingMessage()
{
    //your code here
    //System.out.println("you lose!");
}
public void displayWinningMessage()
{
    //your code here
    //System.out.println("you win!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 600/NUM_COLS;
         height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        //your code here
        if(mouseButton == RIGHT && !clicked){
            if(!marked)
                clicked = false;
            marked = !marked;
        }
        if(mouseButton == LEFT){
            clicked = true;

            if(bombs.contains(this)){
                displayLosingMessage();
            }
            else if(countBombs(r,c) > 0)
                setLabel("" + countBombs(r,c));
            else{ //8 directions
                if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked() )
                    buttons[r-1][c-1].mousePressed();
                if(isValid(r-1,c) && !buttons[r-1][c].isClicked())
                    buttons[r-1][c].mousePressed();
                if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked())
                    buttons[r-1][c+1].mousePressed();
                if(isValid(r,c-1) && !buttons[r][c-1].isClicked())
                    buttons[r][c-1].mousePressed();
                if(isValid(r,c+1) && !buttons[r][c+1].isClicked())
                    buttons[r][c+1].mousePressed();
                if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked())
                    buttons[r+1][c-1].mousePressed();
                if(isValid(r+1,c) && !buttons[r+1][c].isClicked())
                    buttons[r+1][c].mousePressed();
                if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked())
                    buttons[r+1][c+1].mousePressed();
                }
        }
        
    }

    public void draw () 
    {    
        if(marked)
            fill(0,100,251);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        for(int r = 0 ; r<NUM_ROWS; r++)
            for(int c = 0; c<NUM_COLS;c++)
                if(countBombs(r,c) == 1)
                    fill(1,0,254);
                else if(countBombs(r,c) == 2)
                    fill(1,127,1);
                else if(countBombs(r,c) == 3)
                    fill(254,0,0);
                else if(countBombs(r,c) == 4)
                    fill(1,0,128);
                else if(countBombs(r,c) == 5)
                    fill(129,1,2);
                else if(countBombs(r,c) == 6)
                    fill(0,128,129);
                else if(countBombs(r,c) == 7)
                    fill(0,0,0);
                else if(countBombs(r,c) == 8)
                    fill(128,128,128);

        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(c>= 0 && c <NUM_COLS && r>=0 && r <NUM_ROWS ) 
            return true;

        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;

        if( isValid(r-1, c-1) )
            if(bombs.contains(buttons[r-1][c-1]))
                numBombs++;
        if( isValid(r-1, c))
            if(bombs.contains(buttons[r-1][c]))
                numBombs++;
        if( isValid(r-1, c+1))
            if(bombs.contains(buttons[r-1][c+1]))
                numBombs++;
        if( isValid(r, c-1))
            if(bombs.contains(buttons[r][c-1]))
                numBombs++;
        if(isValid(r,c+1))
            if(bombs.contains(buttons[r][c+1]))
                numBombs++;
        if(isValid(r+1,c-1))
            if(bombs.contains(buttons[r+1][c-1]))
                numBombs++;
        if(isValid(r+1,c))
            if(bombs.contains(buttons[r+1][c]))
                numBombs++;
        if(isValid(r+1,c+1))
            if(bombs.contains(buttons[r+1][c+1]))
                numBombs++;


        return numBombs;
    }
}