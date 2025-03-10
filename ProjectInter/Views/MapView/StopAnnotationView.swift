//
//  StopAnnotationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.10.
//

import MapKit

class StopAnnotation: NSObject, MKAnnotation {
    let stop: MapViewStop
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(stop: MapViewStop) {
        self.stop = stop
        self.coordinate = stop.coordinates
        self.title = stop.name
        super.init()
    }
}

class StopAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let circleView = UIView(frame: bounds)
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = bounds.width / 2
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(circleView)
    }
}
