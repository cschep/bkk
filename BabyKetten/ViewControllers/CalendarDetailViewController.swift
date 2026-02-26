import UIKit
import MapKit

class CalendarDetailViewController: UIViewController, MKMapViewDelegate {
    private let event: CalendarEvent
    private let mapView = MKMapView()
    private let descriptionTextView = UITextView()
    private let backgroundImageView = UIImageView(image: UIImage(named: "calendar_detail_bg"))
    private let geocoder = CLGeocoder()
    private var currentPlacemark: MKPlacemark?

    init(event: CalendarEvent) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = event.title
        descriptionTextView.text = event.description

        let city = UserDefaults.standard.string(forKey: "city")
        if city == "1" {
            performForwardGeocode("\(event.location), Seattle, WA")
        } else {
            let searchTerm = event.location
                .replacingOccurrences(of: "pdx", with: "Portland, OR")
                .replacingOccurrences(of: "111 sw ash", with: "111 sw ash, Portland, OR")
            performForwardGeocode(searchTerm)
        }

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        view.addSubview(mapView)

        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.font = .systemFont(ofSize: 22)
        descriptionTextView.backgroundColor = .secondarySystemBackground
        view.addSubview(descriptionTextView)

        let buffer: CGFloat = 45

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: buffer),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buffer),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buffer),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.60),

            descriptionTextView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buffer),
        ])
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pin.canShowCallout = true
        pin.animatesDrop = true
        return pin
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let placemark = currentPlacemark else { return }
        let destination = MKMapItem(placemark: placemark)
        let current = MKMapItem.forCurrentLocation()
        MKMapItem.openMaps(with: [current, destination], launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    // MARK: - Geocoding

    private func performForwardGeocode(_ address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self, let placemark = placemarks?.first else {
                if let error { print("Geocode failed: \(error)") }
                return
            }

            self.currentPlacemark = MKPlacemark(placemark: placemark)

            let annotation = MKPointAnnotation()
            annotation.coordinate = self.currentPlacemark!.location!.coordinate
            annotation.title = self.event.title

            self.mapView.showAnnotations([annotation], animated: false)
            self.mapView.camera.altitude *= 2
        }
    }
}
