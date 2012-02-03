package it.ht.rcs.console.system.view.backend.graph
{
	import flash.geom.Point;
	
	import it.ht.rcs.console.system.view.ScrollableGraph;
	import it.ht.rcs.console.system.view.backend.graph.renderers.DBRenderer;
	import it.ht.rcs.console.system.view.backend.graph.renderers.ShardRenderer;
	
	import spark.primitives.Rect;

	public class BackendGraph extends ScrollableGraph
	{
    
		public var db:DBRenderer;

		public function BackendGraph()
		{
			super();
		}
    
    
    
    
    
    // ----- RENDERING -----
    
    private var bg:Rect;
		public function rebuildGraph():void
		{
			removeAllElements();

			if (db == null) return;

			addElement(db);
			for each (var sr:ShardRenderer in db.shards)
				addElement(sr);

      // The background. We need a dummy component as background for two reasons:
      // 1) it defines maximum sizes
      // 2) will react to mouse events when the user clicks "nowhere" (eg, dragging)
      var p:Point = computeSize();
      bg = new Rect();
      bg.visible = false; // No need to see it, save rendering time...
      bg.width = p.x;
      bg.height = p.y;
      bg.depth = -1000; // Very bottom layer
      addElement(bg);
        
			invalidateSize();
			invalidateDisplayList();

		}
    
    private static const SHARDS_DISTANCE:int   = 70;
    //private static const VERTICAL_DISTANCE:int = 40;
    private static const TOP_DISTANCE:int      = 20;
    
    private static const HORIZONTAL_DISTANCE:int = 60;
    private static const VERTICAL_DISTANCE:int   = 15;
    private static const HORIZONTAL_PAD:int      = 50;
    private static const VERTICAL_PAD:int        = 10;
    
    private function computeSize():Point
    {
      var _width:Number = 0, _height:Number = 0;
      
      if (db != null && db.shards.length > 0)
      {
        
        measuredWidth = measuredMinWidth = (db.shards[0].measuredWidth * db.shards.length) + (SHARDS_DISTANCE * (db.shards.length - 1));
        
        var maxBranch:Number = 0, branch:Number = 0;
        for each (var shard:ShardRenderer in db.shards)
        {
          branch = TOP_DISTANCE + db.height + VERTICAL_DISTANCE;
        }
        measuredHeight = measuredMinHeight = maxBranch;
        
      }
      
//      if (db != null) {
//        
//        _width = (db.collectors[0].width * db.collectors.length) + (HORIZONTAL_DISTANCE * (db.collectors.length - 1)) + HORIZONTAL_PAD * 2;
//        
//        var branch:Number = 0;
//        for each (var collector:CollectorRenderer in db.collectors)
//        {
//          branch = VERTICAL_PAD * 2 + db.height + VERTICAL_DISTANCE + collector.height;
//          collector = collector.nextHop;
//          while (collector != null)
//          {
//            branch += VERTICAL_DISTANCE + collector.height;
//            collector = collector.nextHop;
//          }
//          branch += VERTICAL_DISTANCE + ips[0].height;
//          _height = Math.max(branch, _height);
//        }
//        
//      }
      
      return new Point(_width, _height);
    }
    
    override protected function measure():void
    {
      super.measure();
      var p:Point = computeSize();
      measuredWidth = measuredMinWidth = p.x;
      measuredHeight = measuredMinHeight = p.y;
    }
    
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{

			super.updateDisplayList(unscaledWidth, unscaledHeight);

      var _width:Number = Math.max(unscaledWidth, measuredWidth);
      var _height:Number = Math.max(unscaledHeight, measuredHeight);

      var i:int = 0; // Generic loop index
      var cX:int = 0, cY:int = 0; // Generic currentX, currentY
      var offsetFromCenter:int = 0; // Generic offset
      
			graphics.lineStyle(1, 0x999999, 1, true);


      if (db != null) {

				db.move(_width / 2 - db.measuredWidth / 2, TOP_DISTANCE);

				// Where to draw the first shard?
				if (db.shards != null && db.shards.length > 0) {
          
          var renderer:ShardRenderer = db.shards[0];
          offsetFromCenter = db.shards.length % 2 == 0 ?
            _width / 2 - (db.shards.length / 2 * (HORIZONTAL_DISTANCE + renderer.width)) + HORIZONTAL_DISTANCE / 2 : // Even
            _width / 2 - (Math.floor(db.shards.length / 2) * (HORIZONTAL_DISTANCE + renderer.width)) - renderer.width / 2; // Odd
				
  				// Draw shards
  				for (i = 0; i < db.shards.length; i++) {
  
            renderer = db.shards[i];
  
  					cX = offsetFromCenter + i * (SHARDS_DISTANCE + renderer.width) + renderer.width / 2;
  					cY = db.y + db.height + VERTICAL_DISTANCE;
            renderer.move(cX - renderer.width / 2, cY);
  
  					graphics.moveTo(_width / 2, TOP_DISTANCE + db.height / 2);
  					graphics.lineTo(cX, cY);
  
  				} // End shards
          
        }
        
			} // End db

		}

	}

}