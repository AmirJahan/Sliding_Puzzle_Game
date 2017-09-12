import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var gameView: UIView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var gameViewWith: CGFloat!
    var tileWidth: CGFloat!
    var gameMode: Int!
    
    var empty: CGPoint!
    
    var tilesArr: NSMutableArray = []
    var centersArr: NSMutableArray = []
    
    var matched: Int = 0;
    
    var curTime : Int = 0
    var myTimer : Timer = Timer()
    
    @IBAction func resetAction(_ sender: Any) {
        
        let tempCents: NSMutableArray = centersArr.mutableCopy() as! NSMutableArray
        
        for tile in tilesArr //
        {
            let ranIndex : Int = Int(arc4random_uniform(UInt32(tempCents.count)))
            
            let ranCen = tempCents.object(at: ranIndex)
            (tile as! UILabel).center = ranCen as! CGPoint
            tempCents.removeObject(at: ranIndex)
        }
        
        empty = tempCents.object(at: 0) as! CGPoint
        
        curTime = 0
        myTimer.invalidate()
        myTimer = Timer.scheduledTimer(timeInterval: 1,
                                       target: self,
                                       selector: #selector(timerFunc),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    
    @objc func timerFunc()
    {
        curTime = curTime + 1
        
        // 110 -> 1' : 50"
        
        let min = curTime / 60
        let sec = curTime % 60
        
        let rtimeStr: NSString = NSString.init(format: "%02d\' : %02d\"", min, sec)
        
        timerLabel.text = rtimeStr as String
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameViewWith = gameView.frame.size.width

        gameMode = 4
        tileWidth = gameViewWith / CGFloat( gameMode)
        
        
        blockMaker()
        
        resetAction(Any.self)
    }
    

    
    func blockMaker()
    {
        var xCen: CGFloat = tileWidth / 2
        var yCen: CGFloat = tileWidth / 2
        
        var count : Int = 1
        
        for h in 0..<gameMode
        {
            for v in 0..<gameMode
            {
                let myLabel: MyLabel = MyLabel(frame: CGRect(x: 24356,
                                                             y: 2346,
                                                             width: tileWidth - 4,
                                                             height: tileWidth - 4))
                
                let cen: CGPoint = CGPoint(x: xCen, y: yCen)
                
                myLabel.center = cen
                myLabel.correctCen = cen
                myLabel.text = String(count)
                count += 1
                myLabel.textAlignment = NSTextAlignment.center
                myLabel.font = UIFont.systemFont(ofSize: 30)
                
                
                myLabel.isUserInteractionEnabled = true
                myLabel.backgroundColor = UIColor.red
                gameView.addSubview(myLabel)
                
                tilesArr.add(myLabel)
                centersArr.add(cen)
                
                xCen = xCen + tileWidth
            }
            
            xCen = tileWidth / 2
            yCen = yCen + tileWidth
        }
        
        let lastInd : Int = gameMode*gameMode - 1
        let lastTile: MyLabel = tilesArr.object(at: lastInd) as! MyLabel
        
        lastTile.removeFromSuperview()
        tilesArr.removeObject(at: lastInd)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch : UITouch = touches.first!
        if ( tilesArr.contains(myTouch.view as Any)) {
            
            let thisTile: MyLabel = myTouch.view as! MyLabel
            
            let xDif = pow(empty.x-(thisTile.center.x), 2)
            let yDif = pow(empty.y-(thisTile.center.y), 2)
            
            let dist = sqrt(xDif + yDif)
            
            if (dist == tileWidth)  {
                let temp = thisTile.center
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                myTouch.view?.center = empty
                UIView.commitAnimations()
                
                empty = temp
                
                if ( thisTile.correctCen == thisTile.center )
                {
                    matched += 1
                    thisTile.backgroundColor = UIColor.green
                    
                    if ( matched == (gameMode*gameMode-1))
                    {
                        // u won
                    }
                }
                else if (thisTile.backgroundColor == UIColor.green) {
                    matched -= 1
                    thisTile.backgroundColor = UIColor.red
                }
                print(matched)
                
            }

        }
        
    }
  
}

class MyLabel: UILabel {
    var correctCen: CGPoint!
}



