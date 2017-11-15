package omok.ext;
import omok.base.BoardPanel.BoardPanelListener;
import omok.model.Board;
import omok.model.Board.Place;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import omok.base.BoardPanel;

public privileged aspect ShowVisualCue 
{
	//PointCute for VisualCue is declared , checking for execution of BoardPanel constructor
	pointcut VisualCue(BoardPanel Cue):
		execution(BoardPanel.new(Board, BoardPanelListener))
		&& target(Cue);
	
	//This is use to keep track of the last place the mouse has been and is set to default to 0,0
	private Place Previous = new Place(0, 0);
	//where the after is initialized
	after(BoardPanel Cue): VisualCue(Cue)
	{
		//start a mouse motion listener
		Cue.addMouseMotionListener(new MouseMotionAdapter()
		{
			//define the mouse event as mouseMoved
			public void mouseMoved(MouseEvent e){
				//Make a new Place using the location of the mouse
				Place Grid = Cue.locatePlace(e.getX(), e.getY());
				if(Grid != null)
				{
					//This is to delete previous drawing if the mouse is in moment
					if (Previous.x != Grid.x || Previous.y != Grid.y) 
					{
						Cue.repaint();
						Previous = Grid;
					}
					else
					{
						//here his where the drawing is created
						Graphics g = Cue.getGraphics();
						g.setColor(Color.BLACK);
						int x = Cue.placeSize + Grid.x * Cue.placeSize; 
						int y = Cue.placeSize + Grid.y * Cue.placeSize; 
						int r = Cue.placeSize / 2;              
						g.drawOval(x - r, y - r, r * 2, r * 2);	
					}
				}
			}
		});
	}
}