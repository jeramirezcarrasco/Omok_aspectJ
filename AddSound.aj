package omok.ext;
import java.io.IOException;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import omok.base.OmokDialog;
import omok.model.Board;
import omok.model.Player;

public privileged  aspect AddSound {
	private static final String SOUND_DIR = "/sounds/";
	private static final boolean DISABLED = false;
	after(OmokDialog dialog): this(dialog)
    && execution(void OmokDialog.makeMove(..)) {
    if (DISABLED) { 
        return;
    }
    if(Board.isWonBy(OmokDialog.player))
    {
    	playAudio("piano2.wav");
    }
    else
    {
    	if(OmokDialog.player.name().equals("White"))
    		playAudio("asd.wav");
    	else
    		playAudio("fgh.wav");
    }  
}
	 public static void playAudio(String filename) {
		 
	      try {
	          AudioInputStream audioIn = AudioSystem.getAudioInputStream(
		    AddSound.class.getResource(SOUND_DIR + filename));
	          Clip clip = AudioSystem.getClip();
	          clip.open(audioIn);
	          clip.start();
	      } catch (UnsupportedAudioFileException 
	            | IOException | LineUnavailableException e) {
	          e.printStackTrace();
	      }
	    }

}

