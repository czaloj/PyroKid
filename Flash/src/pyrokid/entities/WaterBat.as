package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.tools.*
    import physics.*;
    
    public class WaterBat extends BackAndForthEnemy {
        public var batHead:MovieClip;
        private var HEAD_ROT_OFFSET:int = 225; //not sure what happened here
        private var X_CENTER_TO_HEAD:int = 7;
        private var LENGTH_OF_HEAD:int = 10;
        private var dirToShoot:int;
        private var timeToWaterball:int = 0;
        
        
        public function WaterBat(level:Level) {
            
            var mc:MovieClip = new Embedded.WaterBatSWF() as MovieClip;
            batHead = mc.head;
            
            var swf:Sprite = mc;
            super(level, swf, 1, 45, 35, 8, 9, 26, 19, false);
            batHead.gotoAndStop(1);
        }
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                kill(level);
                var die:MovieClip = new Embedded.WaterBatDieSWF() as MovieClip;
                die.scaleX = swf.scaleX;
                die.scaleY = swf.scaleY;
                var xpos:int = (direction == Constants.DIR_RIGHT ? x : x + wArt);
                var briefClip:BriefClip = new BriefClip(new Vector2(xpos, y), die);
                level.addChild(briefClip);
                level.briefClips.push(briefClip);
            }
            return lit;
        }
        
        public override function update(level:Level):void {
            super.update(level);
            
            var xdis:int = level.player.x - this.x;
            var ydis:int = level.player.y - this.y;
            dirToShoot = Utils.getQuadrant(xdis, ydis);
            
            if (dirToShoot == Constants.DIR_UP) {
                this.batHead.rotation = -90 - HEAD_ROT_OFFSET;
            } else if (dirToShoot == Constants.DIR_DOWN) {
                this.batHead.rotation = 90 - HEAD_ROT_OFFSET;
            } else if (dirToShoot != this.direction) {
                dirToShoot = Constants.DIR_DOWN;
                this.batHead.rotation = 90 - HEAD_ROT_OFFSET;
            } else {
                this.batHead.rotation =  - HEAD_ROT_OFFSET;
            }
            
            if (timeToWaterball < Constants.WATERBALL_COOLDOWN) {
                timeToWaterball ++;
            } else {
                timeToWaterball = 0;
                    
                // Find center of water bat
                var shootSpot:Vector2i = this.getCenter();
                
                // Offset to head depending on direction
                shootSpot.AddV(new Vector2i((direction == Constants.DIR_RIGHT ? X_CENTER_TO_HEAD : -X_CENTER_TO_HEAD), 0));
                
                // Offset to end of head depending on rotation of head
                var headShift:Vector2i = Utils.getXYMultipliers(dirToShoot).MulD(LENGTH_OF_HEAD);
                shootSpot.AddV(headShift);
                
                var drift:Vector2 = new Vector2(0, 0);
                if (direction == Constants.DIR_LEFT) {
                    drift.x = -2;
                } else if (direction == Constants.DIR_RIGHT) {
                    drift.x = 2;
                }
                level.launchWaterball(shootSpot.x, shootSpot.y, 5, dirToShoot, drift);
                
                
            }
            
        }
    }

}