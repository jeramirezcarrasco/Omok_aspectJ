package omok.ext;

import omok.base.BoardPanel.BoardPanelListener;
import omok.model.Board;
import omok.model.Player;
import omok.model.Board.Place;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.util.ArrayList;
import java.util.List;
import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.KeyStroke;

import omok.base.BoardPanel;
import omok.base.OmokDialog;

public privileged aspect AddCheatKey {
	
	static Player CurrPlayer;
	private static List<Place> winningRow = new ArrayList<>(0);

	after(OmokDialog Keydialog): this(Keydialog) && execution(void OmokDialog.makeMove(..)) 
	{
		CurrPlayer = Keydialog.player;
	}

	pointcut AddCheat(BoardPanel Cht):
		execution(BoardPanel.new(Board, BoardPanelListener))
		&& target(Cht);

	static List<Place> places;
	// This is use to keep track of the last place the mouse has been and is set to
	// default to 0,0
	private Place Previous = new Place(0, 0);

	// where the after is initialized
	after(BoardPanel Cht): AddCheat(Cht)
	{
		Graphics g = Cht.getGraphics();
		places = Cht.board.places;
		ActionMap map = Cht.getActionMap();
		int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
		InputMap inputMap = Cht.getInputMap(condition);
		String reload = "Cheat";
		inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), reload);
		map.put(reload, new KeyAction(Cht, reload));
	}

	@SuppressWarnings("serial")
	private static class KeyAction extends AbstractAction {
		private final BoardPanel boardPanel;
		
		private KeyAction(BoardPanel boardPanel, String command) {
			this.boardPanel = boardPanel;
			
			putValue(ACTION_COMMAND_KEY, command);
		}

		/** Called when a cheat is requested. */
		public void actionPerformed(ActionEvent event) {
			
			if (isWonBy(CurrPlayer)) {
				for (Place P : winningRow)
				{
					Graphics g = boardPanel.getGraphics();
					g.setColor(Color.RED);
					int x = 20 + P.x * 20;
					int y = 20 + P.y * 20;
					int r = 20 / 2;
					g.fillOval(x - r, y - r, r * 2, r * 2);
				}
			}
		}
	}

	private static boolean isWonBy(int x, int y, int dx, int dy, Player player) {
		// consecutive places occupied by the given player
		final List<Place> row = new ArrayList<>(5);

		// check left/lower side of (x,y)
		int sx = x; // starting x and y
		boolean Jump = true;
		int sy = y; // i.e., (sx, sy) <----- (x,y)
		while (!(dx > 0 && sx < 0) && !(dx < 0 && sx >= 15) && !(dy > 0 && sy < 0) && !(dy < 0 && sy >= 15)) {
			
			if (isOccupiedBy(sx, sy, player) && row.size() < 5) {
				row.add(at(sx, sy));
				sx -= dx;
				sy -= dy;
			} 
			else if (Jump && isEmpty(sx, sy)) {
				row.add(at(sx, sy));
				sx -= dx;
				sy -= dy;
				Jump = false;
			}
			else break;

		}

		// check right/higher side of (x,y)
		int ex = x + dx; // ending x and y
		int ey = y + dy; // i.e., (x,y) -----> (ex, ey)
		while (!(dx > 0 && ex >= 15) && !(dx < 0 && ex < 0) && !(dy > 0 && ey >= 15) && !(dy < 0 && ey < 0)
				&& isOccupiedBy(ex, ey, player) && row.size() < 5) {
			row.add(at(ex, ey));
			ex += dx;
			ey += dy;
		}

		if (row.size() >= 5) {
			winningRow = row;
		}
		return row.size() >= 5;
	}

	public static boolean isOccupiedBy(int x, int y, Player player) {
		return at(x, y).occupant() == player;
	}

	public static Place at(int x, int y) {
		return places.stream().filter(p -> p.x == x && p.y == y).findAny().get();
	}

	public Iterable<Place> winningRow() {
		return winningRow;
	}

	public static boolean isEmpty(int x, int y) {
		return at(x, y).isEmpty();
	}

	public static boolean isWonBy(Player player) {
		return places.stream().anyMatch(p -> isWonBy(p.x, p.y, 1, 0, player) // horizontal
				|| isWonBy(p.x, p.y, 0, 1, player) // vertical
				|| isWonBy(p.x, p.y, 1, 1, player) // diagonal(\)
				|| isWonBy(p.x, p.y, 1, -1, player)); // diagonal(/)
	}

}
