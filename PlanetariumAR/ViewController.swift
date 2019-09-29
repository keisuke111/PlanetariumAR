//
//  ViewController.swift
//  PlanetariumAR
//
//  Created by 北邑圭佑 on 2019/08/28.
//  Copyright © 2019 北邑圭佑. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        // 解析情報を表示
        #warning("debug")
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.showsStatistics = true
        
        // 現在位置情報取得
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
        
        // アプリの使用中に位置情報サービスを使用するユーザーの許可を要求
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 100
            locationManager.startUpdatingLocation()
        }
        
        // cavファイル読み込み
        var csvArray = [String]()
        guard let csvPath = Bundle.main.path(forResource: "StarData", ofType: "csv") else {
            return
        }
        do {
            let csvString = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            csvArray = csvString.components(separatedBy: "\n")
            // 最後の改行を削除
            csvArray.removeLast()
        } catch _ as NSError {
            return
        }
        
        for star in csvArray {
            let starDetail = star.components(separatedBy: ",")
            print("HIP番号: \(starDetail[0])\n名前: \(starDetail[1])\n赤経: \(starDetail[2])\n赤緯: \(starDetail[3])\n視等級: \(starDetail[4])\n")
        }
        
        // 時刻を取得
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy,MM,dd,HH,mm,ss"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        let currentTime = format.string(from: date).split(separator: ",")

        print("現在時刻: \(currentTime[0])/\(currentTime[1])/\(currentTime[2]) \(currentTime[3]):\(currentTime[4]):\(currentTime[5])")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        // 平面、垂直面を検知
        configuration.planeDetection = [.horizontal, .vertical]
        // 環境光に合わせてレンダリング
        configuration.isLightEstimationEnabled = true
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // 位置情報が変わるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        print("緯度: \(latitude!)\n経度: \(longitude!)")
    }

    // 星の位置計算
    func calculateStarCoordinate() {
        
    }
}

