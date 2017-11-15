package omok.ext;
import java.awt.Color;
import omok.base.ColorPlayer;
import omok.base.OmokDialog;
import omok.model.Player;
public privileged aspect AddOpponent {
	//Here the White and Black opponent are defined
	Player White = new ColorPlayer("White", Color.WHITE);
	Player Black = new ColorPlayer("Black", Color.BLACK);
	//The advice is declared checking for makeMove execution
	after(OmokDialog dialog): this(dialog) && execution(void OmokDialog.makeMove(..)) 
	{
		//if player is White change to Black
		if (dialog.player.name().equals("White")) {
			dialog.player = Black;
		//if player is Black change to White
		} else if (dialog.player.name().equals("Black")) {
			dialog.player = White;
		}
	}
}
