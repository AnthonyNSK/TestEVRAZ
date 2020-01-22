//
//  ViewController.swift
//  TestEVRAZ
//
//  Created by Kuzhelev Anton on 21.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var trackView: MainView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var arrayOfWays : [UIBezierPath] = []
    var arrayOfCarViews : [UIImageView] = []
    var results : [Result] = []
    var timerOfGameEvents : Timer?
    var timer : Timer?
    var time : Float = 0 { didSet {
        timerLabel.text = String(format: "%.1f", time)
        }}
    var isLoad : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoad == false {
            createCars()
            createWays()
            isLoad = true
        }
        
    }
    
    func createCars() {
        
        let carViewGreen = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        carViewGreen.center = CGPoint(x: trackView.frame.width - 30, y: trackView.frame.height/2)
        carViewGreen.backgroundColor = UIColor.green
        trackView.addSubview(carViewGreen)
        
        arrayOfCarViews.append(carViewGreen)
        
        let carViewPurple = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        carViewPurple.center = CGPoint(x: trackView.frame.width - 50, y: trackView.frame.height/2)
        carViewPurple.backgroundColor = UIColor.purple
        trackView.addSubview(carViewPurple)
        
        arrayOfCarViews.append(carViewPurple)
        
        let carViewYellow = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        carViewYellow.center = CGPoint(x: trackView.frame.width - 70, y: trackView.frame.height/2)
        carViewYellow.backgroundColor = UIColor.yellow
        trackView.addSubview(carViewYellow)
        
        arrayOfCarViews.append(carViewYellow)
    }
    
    func createWays() {
        
        let greenWay = UIBezierPath(ovalIn: CGRect(x: 30, y: 30, width: trackView.frame.width - 60, height: trackView.frame.height - 60))
        arrayOfWays.append(greenWay)
        
        let purpleWay = UIBezierPath(ovalIn: CGRect(x: 50, y: 50, width: trackView.frame.width - 100, height: trackView.frame.height - 100))
        arrayOfWays.append(purpleWay)
        
        let yellowWay = UIBezierPath(ovalIn: CGRect(x: 70, y: 70, width: trackView.frame.width - 140, height: trackView.frame.height - 140))
        arrayOfWays.append(yellowWay)
        
    }
    
    func createAnimations() {
        
        var i = 0
        for carView in arrayOfCarViews {
            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = 2
            animation.repeatCount = 3
            animation.path = arrayOfWays[i].cgPath
            animation.delegate = self
            animation.setValue(carView.layer, forKey: "animationLayer")
            animation.setValue(i, forKey: "numberOfCar")
            i+=1
            carView.layer.add(animation, forKey: "MyAnimation")
        }
    }
    
    func pauseAnimation(carView: UIImageView){
        let pausedTime = carView.layer.convertTime(CACurrentMediaTime(), from: nil)
        carView.layer.speed = 0.0
        carView.layer.timeOffset = pausedTime
        
        perform(#selector(resumeAnimation), with: carView, afterDelay: 0.5)
    }
    
    @objc func resumeAnimation(carView: UIImageView){
        let pausedTime = carView.layer.timeOffset
        carView.layer.speed = 1.0
        carView.layer.timeOffset = 0.0
        carView.layer.beginTime = 0.0
        let timeSincePause = carView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        carView.layer.beginTime = timeSincePause
    }
    
    func createTimerOfGameEvents() {
        
        if timerOfGameEvents == nil {
            timerOfGameEvents = Timer.scheduledTimer(timeInterval: 0.7,
                                                     target: self,
                                                     selector: #selector(stopCar),
                                                     userInfo: nil,
                                                     repeats: true)
        }
    }
    
    func createStopWatch() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(showTime),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc func showTime() {
        time += 0.1
    }
    
    func checkEndAnimations() -> Bool{
        for carView in arrayOfCarViews {
            if carView.layer.animation(forKey: "MyAnimation") != nil {
                return false
            }
        }
        return true
    }
    
    @objc func stopCar() {
        
        
        let carView = arrayOfCarViews.randomElement()
        if carView!.layer.animation(forKey: "MyAnimation") != nil && carView!.layer.speed == 1.0 {
            pauseAnimation(carView: carView!)
            
        }
    }
    
    func clean() {
        timerOfGameEvents?.invalidate()
        timerOfGameEvents = nil
        
        timer?.invalidate()
        timer = nil
        time = 0
        
        for carView in arrayOfCarViews {
            carView.layer.removeAllAnimations()
        }
        
    }
    
    func saveResult(num: Int) {
        switch num {
        case 0:
            let result = Result(name: "Green Car", time: String(format: "%.1f", time))
            results.append(result)
        case 1:
            let result = Result(name: "Purple Car", time: String(format: "%.1f", time))
            results.append(result)
        case 2:
            let result = Result(name: "Yellow Car", time: String(format: "%.1f", time))
            results.append(result)
        default:
            print("???")
        }
        
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        clean()
        createAnimations()
        createTimerOfGameEvents()
        createStopWatch()
        results = []
        
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        clean()
    }
    
    @IBAction func resultsAction(_ sender: UIButton) {
        clean()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Show") {
            let vc = segue.destination as! ResultsTableViewController
            vc.results = self.results
        }
    }
    
}
extension ViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            let layer = anim.value(forKey: "animationLayer") as! CALayer
            layer.removeAllAnimations()
            
            let number = anim.value(forKey: "numberOfCar") as! Int
            saveResult(num: number)
            
            if checkEndAnimations() {
                clean()
                
            }
        }
    }
}

