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
    var shouldShowTitle: Bool = false
    
    init(stop: MapViewStop) {
        self.stop = stop
        self.coordinate = stop.coordinates
        self.title = stop.name
        super.init()
    }
}

class StopAnnotationView: MKAnnotationView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        setupImageView()
        setupLabelView()
    }
    
    private func setupImageView() {
        backgroundColor = .clear
        
        let circleView = UIView(frame: bounds)
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = bounds.width / 2
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(circleView)
    }
    
    private func setupLabelView() {
        addSubview(label)
        
        let labelWidth: CGFloat = 200
        label.frame = CGRect(
            // Centers the label relative to the circle
            x: -labelWidth / 2 + bounds.width / 2,
            y: bounds.height + 2,
            width: labelWidth,
            height: 20
        )
        
        updateLabelView()
    }
    
    private func updateLabelView() {
        if let stopAnnotation = annotation as? StopAnnotation {
            if stopAnnotation.shouldShowTitle {
                label.text = stopAnnotation.title ?? ""
            } else {
                label.text = ""
            }
        }
    }
}
