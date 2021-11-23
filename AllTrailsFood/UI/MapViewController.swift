//
//  MapViewController.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    private var mapView: MKMapView = .init()
    private var manager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                centerCoordinateOnMap(coordinate: coordinate)
            }
        }
    }
    var placeData: [Place]? {
        didSet {
            updateMapContent()
        }
    }

    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateMapContent()
    }

    // MARK: private methods

    private func setupUI() {
        mapView.insertAndPinToParentView(view)
        mapView.showsCompass = false  // Hide built-in compass
        mapView.delegate = self

        mapView.registerAnnotationClass(PlaceAnnotationView.self)
    }

    private func centerCoordinateOnMap(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: false)
    }

    private func updateMapContent() {
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }

        placeData?.forEach { (place) in
            let viewModel = PlaceViewModel(place: place)
            guard let coordinate = viewModel.locationCoordinate else { return }
            let annotation = PlaceAnnotation(coordinate: coordinate, viewModel: viewModel)
            mapView.addAnnotation(annotation)
        }

        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view: PlaceAnnotationView = mapView.dequeueReusableView(for: annotation)
        view.configure(with: annotation)
        return view
    }
}
