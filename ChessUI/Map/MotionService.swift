//
//  MotionService.swift
//  ChessUI
//
//  Created by Felix Walberg on 11/12/24.
//

import Foundation
import CoreMotion
import SwiftUI

class MotionService: NSObject, CLLocationManagerDelegate, ObservableObject  {
    var motionManager: CMMotionManager?
    var timer: Timer?
    @Published var currentGyro: CMLogItem?
    @Published var currentMagnetometer: CMMagnetometerData?
    
    override init(){
        super.init()
        motionManager = CMMotionManager()
    }
    
    func startMagnetometer() {
        if((motionManager?.isMagnetometerAvailable) != nil) {
//            self.motionManager?.showsDeviceMovementDisplay = true
            self.motionManager?.magnetometerUpdateInterval = 1.0 / 50.0
            self.motionManager?.startMagnetometerUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/5.0),
                               repeats: true, block: { (timer) in
                // Get the gyro data.
                if let data = self.motionManager?.magnetometerData {
                    self.currentMagnetometer = data
//                    print(self.currentMagnetometer?.magneticField)
//                    print(data)
                
                }
            })
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        }
    }
        
        func stopMagnetometer() {
            if self.timer != nil {
               self.timer?.invalidate()
               self.timer = nil


               self.motionManager?.stopMagnetometerUpdates()
            }
        }
    
    func startGyros() {
        if ((motionManager?.isGyroAvailable) != nil) {
          self.motionManager?.gyroUpdateInterval = 1.0 / 50.0
          self.motionManager?.startGyroUpdates()


          // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/5.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motionManager?.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z
//                print("x: \(x)")
//                 print("y: \(y)")
//                 print("z: \(z)")


                // Use the gyroscope data in your app.
             }
          })


          // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
       }
    }


    func stopGyros() {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil


          self.motionManager?.stopGyroUpdates()
       }
    }
    
}

