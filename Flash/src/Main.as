package  {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import net.hires.debug.Stats;
    import pyrokid.tools.LogMaster;
    import pyrokid.Constants;
	import ui.playstates.StateController;
	import ui.*;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.Key;
    import pyrokid.dev.LevelEditor;
    import pyrokid.GameSettings;
    import pyrokid.Embedded;
    
    [Frame(factoryClass="Preloader")]
    public class Main extends Sprite {
		
		public static var MainStage:Stage;
        public static var log:LogMaster;
		
		private var curr_state:int;        
		
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            // entry point
            log = new LogMaster();
            
			MainStage = stage;
            Key.init(stage);
            			
			Utils.loadSavedData();
			            
            if (Constants.MUSIC_STARTS_ON) Embedded.musicSound.play(0, 999999);

            
			addChild(StateController.display);
			StateController.goToMainMenu();
            
            if (Constants.DEBUG_DRAW) {
                addChild(new Stats());
            }
        }
    }

}