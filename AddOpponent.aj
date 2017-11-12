package omok.ext;
import java.awt.Color;
import omok.base.ColorPlayer;
import omok.base.OmokDialog;
import omok.model.Player;
public privileged aspect AddOpponent {
	private final boolean DISABLED = false;
	Player White = new ColorPlayer("White", Color.WHITE);
	Player Black = new ColorPlayer("Black", Color.BLACK);
	after(OmokDialog dialog): this(dialog) && execution(void OmokDialog.makeMove(..)) 
	{	
		if (DISABLED) {
			return;
		}
		if (OmokDialog.player.name().equals("White")) {
			OmokDialog.player = Black;
		} else if (OmokDialog.player.name().equals("Black")) {
			OmokDialog.player = White;
		}
	}
}
