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
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    // Limit to private setting to enforce disposability
    // of the view
    private var shuttleIsSelected: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String? = "shuttle") {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        setupView()
    }
    
    convenience init(annotation: MKAnnotation?, reuseIdentifier: String? = "shuttle", isSelected: Bool = false) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.shuttleIsSelected = isSelected
        
        // Call manually because didSet does nothing
        // until after initialization
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        setupImageView()
        setupLabelView()
        setupAccessibilityElements()
    }
    
    private func setupImageView() {
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
    }
    
    private func setupAccessibilityElements() {
        guard let shuttleAnnotation = annotation as? ShuttleAnnotation else { return }
        
        isAccessibilityElement = true
        accessibilityLabel = "Shuttle"
        accessibilityValue = shuttleAnnotation.shuttle.id
        accessibilityTraits = .button
        accessibilityHint = "Tap to view info about this shuttle."
    }
    
    private func updateView() {
        guard let shuttleAnnotation = annotation as? ShuttleAnnotation else {
            return
        }
        
        if shuttleIsSelected {
            // Add the label and/or styling
            label.text = shuttleAnnotation.shuttle.name
        } else {
            // Remove the label and/or styling
            label.text = ""
        }
    }
}
