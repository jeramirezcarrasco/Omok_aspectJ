package omok.ext;
import java.awt.Color;
import java.awt.Graphics;
import java.util.List;
import omok.model.Board;
import omok.model.Board.Place;
import omok.base.BoardPanel;
import omok.base.OmokDialog;
import omok.base.BoardPanel.BoardPanelListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.awt.event.ActionEvent;

public privileged aspect EndGame 
{
	//Around used to stop the makeMove is the game is over
	void around(OmokDialog dialog): this(dialog)
    && execution(void OmokDialog.makeMove(..)) 
    {
		if (dialog.board.isGameOver()) 
		{ 
			return;
		}
		else
			 proceed(dialog);
	}
	//After used to show a message when the game is over
	after(OmokDialog dialogMove): this(dialogMove)
    && execution(void OmokDialog.makeMove(..))
	{
		if (dialogMove.board.isGameOver()) 
		{
			if(dialogMove.board.isFull())
			{	
				dialogMove.showMessage("Game is over, is a tie");
			}
			else
			{
				dialogMove.showMessage("Game is over, winner is :"+ dialogMove.player.name() );
			}
		}
	}
	//Around used to remove the question of PlayButton
	void around(OmokDialog dialogEnd): this(dialogEnd)
    && execution(void OmokDialog.playButtonClicked(ActionEvent))
	{
		if (dialogEnd.board.isGameOver()) 
		{
			dialogEnd.startNewGame();
		}
		else
		{
			proceed(dialogEnd);
		}
	}
	
	//Using the Mouse listener, the program check is the game is over and then draw over the winning row
	pointcut VisualCueEnd(BoardPanel CueEnd):
		execution(BoardPanel.new(Board, BoardPanelListener))
		&& target(CueEnd);
	after(BoardPanel CueEnd): VisualCueEnd(CueEnd)
	{
			CueEnd.addMouseMotionListener(new MouseMotionAdapter()
			{
				public void mouseMoved(MouseEvent e){
						List<Place> winningRow = CueEnd.board.winningRow;
						for(Place P : winningRow)
						{
							Graphics gt = CueEnd.getGraphics();
							gt.setColor(Color.BLUE);
							int x = CueEnd.placeSize + P.x * CueEnd.placeSize; 
							int y = CueEnd.placeSize + P.y * CueEnd.placeSize; 
							int r = CueEnd.placeSize / 2;              
							gt.fillOval(x - r, y - r, r * 2+1, r * 2+1);
						}
					}
			});
	}
}