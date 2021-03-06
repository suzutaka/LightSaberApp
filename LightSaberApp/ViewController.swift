//
//  ViewController.swift
//  LightSaberApp
//
//  Created by nowall on 2018/10/27.
//  Copyright © 2018 鈴木貴大. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class ViewController: UIViewController {

    let motionManager: CMMotionManager = CMMotionManager()
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    // ボタンを押した時の音を出すための再生オブジェクトを格納します。
    var startAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    // 振っている最中かどうかの状態を格納します。
    // 振り始めるとtrue, 振り終わるとfalseになります。
    var startAccel: Bool = false
    
    
    // アプリで使用する音の準備
    func setupSound() {
        // ボタンを押した時の音を設定します。
        if let sound = Bundle.main.path(forResource: "light_saber1", ofType: ".mp3") {
            
            startAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            
            startAudioPlayer.prepareToPlay()
        }
        
        
        // iPhoneを振った時の音を設定します。
        if let sound = Bundle.main.path(forResource: "light_saber3", ofType: ".mp3") {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            
            audioPlayer.prepareToPlay()
        }
        
        
    }
    
    // 加速度センサーからの値取得の開始とその処理
    func startGetAccelerometer() {
        // 加速度センサーの検出間隔を指定
        motionManager.accelerometerUpdateInterval = 1 / 100
        
        // 検出開始と検出後の処理
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData: CMAccelerometerData?, error: Error?) in
         
            if let acc = accelerometerData {
                // 各角度への合計速度を取得します。
                let x = acc.acceleration.x
                let y = acc.acceleration.y
                let z = acc.acceleration.z
                let synthetic = (x * x) + (y * y) + (z * z)
                
               // 一定以上の速度になったら音を鳴らします。
                if self.startAccel == false && synthetic >= 8 {
                    // 振っている最中に音の再生が重複しないようにstartAccelをtrueにします。
                    self.startAccel = true
                    
                    // 音が再生中は重ねて再生できないので、再生開始位置に強制移動して最初から再生し直します。
                    self.audioPlayer.currentTime = 0
                    self.audioPlayer.play()
                }
                
                // startAccelがtrue(振っている最中)かつ速度が一定以下になる(＝振るのを止める)と
                // startAccelをfalseにして再び音が鳴るようにします。
                if self.startAccel == true && synthetic < 1 {
                    self.startAccel = false
                }
 
                // 一定以上の速度になったら音を鳴らします。
                if synthetic >= 8 {
                    self.audioPlayer.play()
                }
            }
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         setupSound()
    }

    
    @IBAction func tappedStartButton(_ sender: Any) {
        startAudioPlayer.play()
        startGetAccelerometer()
    }
 
    
}

