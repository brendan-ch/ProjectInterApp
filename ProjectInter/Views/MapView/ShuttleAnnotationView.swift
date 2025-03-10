//
//  MapAnnotationViews.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.10.
//

import MapKit

class ShuttleAnnotation: NSObject, MKAnnotation {
    let shuttle: MapViewShuttle
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(shuttle: MapViewShuttle) {
        self.shuttle = shuttle
        self.coordinate = shuttle.coordinates
        self.title = shuttle.name
        super.init()
    }
}

class ShuttleAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        guard let shuttleAnnotation = annotation as? ShuttleAnnotation else { return }
        
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor(hex: shuttleAnnotation.shuttle.routeColorHex ?? "#000000")
        backgroundView.layer.cornerRadius = bounds.width / 2
        backgroundView.layer.borderWidth = 4
        backgroundView.layer.borderColor = UIColor.white.cgColor
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let busImage = UIImageView(image: UIImage(systemName: "bus.fill", withConfiguration: imageConfig))
        busImage.tintColor = .white
        busImage.frame = bounds.insetBy(dx: 6, dy: 6)
        busImage.contentMode = .scaleAspectFit
        
        addSubview(backgroundView)
        addSubview(busImage)
        
        // Accessibility
        isAccessibilityElement = true
        accessibilityLabel = "Shuttle"
        accessibilityValue = shuttleAnnotation.shuttle.id
        accessibilityTraits = .button
        accessibilityHint = "Tap to view info about this shuttle."
    }
}
