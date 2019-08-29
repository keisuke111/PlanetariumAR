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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        // 解析情報を表示
        #warning("debug")
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.showsStatistics = true
        
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

}

