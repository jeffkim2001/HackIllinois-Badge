//
//  HIUserBadgeViewController.swift
//  HackIllinois-Badge
//
//  Created by Jeff Kim on 9/13/19.
//  Copyright © 2019 Jeff Kim. All rights reserved.
//

import UIKit

struct HackIllinois: Decodable {
    var events : [Event]?
}

struct Event: Decodable {
    var name : String?
    var description : String?
    var startTime : Int64?
    var endTime: Int64?
    var locations : [Location]?
}

struct Location: Decodable {
    var description : String?
    var latitude : Double?
    var longitude : Double?
}

class HIUserBadgeViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIStackView!
    @IBOutlet weak var participantName: UILabel!
    @IBOutlet weak var eventInformation: UILabel!
    @IBOutlet weak var rightBuildingView: UIView!
    @IBOutlet weak var roofView: UIView!
    @IBOutlet weak var leftBuildingView: UIView!
    
    var HIAPIURL: String =  "https://api.hackillinois.org/event/"
    var hackIllinois: HackIllinois?
    let attributes = [NSAttributedString.Key.font : UIFont(name: "Marker Felt", size: 17)!, NSAttributedString.Key.foregroundColor : UIColor(red: 150/255, green: 193/255, blue: 144/255, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBuildingViews()
        retrieveEventData()
    }
    
    func retrieveEventData() {
        
        guard let url = URL(string: HIAPIURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                self.hackIllinois = try JSONDecoder().decode(HackIllinois.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func updateUI() {
        guard let events = hackIllinois?.events else {
            return
        }
        guard let event2Locations = events[1].locations else {
            return
        }
        guard let latitude = event2Locations[0].latitude else {
            return
        }
        guard let longitude = event2Locations[0].longitude else {
            return
        }
        self.eventInformation.attributedText = NSAttributedString(string: "Latitude: \(latitude)°, Longitude: \(longitude)°", attributes: attributes)
    }
    
    
    func setUpBuildingViews() {
        roundRoofCorners()
        setShadowsForBuildings()
    }
    
    func roundRoofCorners() {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: roofView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: roofView.bounds.height/2, height: 5)).cgPath
        roofView.layer.mask = shape
    }
    
    
    
    func setShadowsForBuildings() {
        contentView.setShadow()
        leftBuildingView.setShadow()
        rightBuildingView.setShadow()
    }
    
    
}

extension UIView {
    func setShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = false
    }
}

