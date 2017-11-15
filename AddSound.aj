package omok.ext;
import java.io.IOException;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import omok.base.OmokDialog;

public privileged  aspect AddSound {
	//Here the Folder for sounds is defined
	private static final String SOUND_DIR = "/sounds/";
	
	//After advice checking for Make Move
	after(OmokDialog dialog): this(dialog)
    && execution(void OmokDialog.makeMove(..)) {
	//if the Game is won play the won sound
    if(dialog.board.isGameOver())
    {
    	playAudio("piano2.wav");
    }
    else
    {
    	//if White moves play sound
    	if(dialog.player.name().equals("White"))
    		playAudio("asd.wav");
    	//if else play second player sound
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

