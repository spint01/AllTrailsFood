//
//  MainContainerViewController.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import UIKit
import CoreLocation

enum ViewType {
    case list
    case map

    // title is opposite current view
    var overlayTitle: String {
        switch self {
        case .list: return "Map"
        case .map: return "List"
        }
    }
    var overlayImage: UIImage? {
        switch self {
        case .list: return UIImage(systemName: "list.bullet")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .map: return UIImage(systemName: "map")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }
}

final class MainContainerViewController: UIViewController {

    enum Constant {
        static let overlayVerticalPadding: CGFloat = 30
    }

    static var favoritePlaces: Set<String> = []

    private let contentView: UIView = .init()
    private var currentController: UIViewController?
    private var listViewController: ListViewController?
    private var mapViewController: MapViewController?
    private var searchView: SearchView = .init()
    private var overlayView: OverlayView = .init()

    private var viewType: ViewType = .list
    private var placeData: [Place]? {
        didSet {
            if self.viewType == .list {
                listViewController?.placeData = placeData
            } else {
                mapViewController?.placeData = placeData
            }
        }
    }
    private var overlayBottomConstraint: NSLayoutConstraint?
    private var manager: CLLocationManager?
    private var coordinate: CLLocationCoordinate2D? {
        didSet {
            if self.viewType == .map {
                mapViewController?.coordinate = coordinate
            }
            if let coordinate = coordinate {
                let text = "\(coordinate.latitude),\(coordinate.longitude)"
                let searchQuery = PlacesSearchHandler(queryText: "restaurants", locationText: text)
                searchQuery.performQuery { [weak self] places, error in
                    print("*** finished query: \(text) places count: \(places?.count ?? 0)")
                    self?.placeData = places
                }
            }
        }
    }

    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = navigationItemView(imageName: "logo-with-name", titleText: " at Lunch")
        view.backgroundColor = .atGray
        setupUI()

        displayListController()
        overlayView.configure(with: viewType)
        searchLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: setup

    private func setupUI() {
        setupSearchView()
        setupOverlayView()
        setupContentView()
    }

    private func setupSearchView() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.heightAnchor.constraint(equalToConstant: 70.0),
            searchView.topAnchor.constraint(equalTo: view.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        searchView.delegate = self
    }

    private func setupOverlayView() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        overlayBottomConstraint = overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constant.overlayVerticalPadding)
        NSLayoutConstraint.activate([
            overlayView.heightAnchor.constraint(equalToConstant: 44.0),
            overlayView.widthAnchor.constraint(equalToConstant: 90.0),
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayBottomConstraint!,
        ])
        overlayView.delegate = self
    }

    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.backgroundColor = .cyan
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func displayListController() {
        if listViewController == nil {
            listViewController = ListViewController()
        }
        swapViewControllers(listViewController)
        listViewController?.placeData = placeData
    }

    private func displayMapController() {
        if mapViewController == nil {
            mapViewController = MapViewController()
        }
        swapViewControllers(mapViewController)
        mapViewController?.placeData = placeData
        mapViewController?.coordinate = coordinate
    }

    // MARK: Helper methods

    private func swapViewControllers(_ newController: UIViewController?) {
        guard let newController = newController, newController != currentController else { return }
        if let currentController = currentController {
            currentController.removeFromParentController()
        }
        currentController = newController
        addChildController(newController, toView: contentView)
        view.bringSubviewToFront(searchView)
        view.bringSubviewToFront(overlayView)
    }

    func navigationItemView(imageName: String, titleText: String) -> UIView {
        // Creates a new UIView
        let titleView = UIView()

        let label = UILabel()
        label.text = " \(titleText)"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .ultraLight)
        label.textColor = .gray
        label.sizeToFit()
        titleView.addSubview(label)

        if let image = UIImage(named: imageName) {
            // Maintains the image's aspect ratio:
            let imageAspect = image.size.width / image.size.height
            let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: imageX, y: label.frame.origin.y, width: label.frame.size.height * imageAspect, height: label.frame.size.height)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit

            titleView.addSubview(imageView)
        }
        titleView.sizeToFit()
        
        return titleView
    }

    // MARK: location handling

    private func searchLocation() {
        if manager == nil {
            let manager = CLLocationManager()
            manager.delegate = self
            manager.requestWhenInUseAuthorization() // Does nothing if status is determined.
            self.manager = manager
        }
    }

    private func authStatusChanged(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager?.startUpdatingLocation()
        }
    }

    // MARK: keyboard show/hide

    @objc func keyboardWillShow(_ notification: NSNotification) {
        layoutWithKeyboardFrame(notification)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        layoutWithKeyboardFrame(notification)
    }

    func layoutWithKeyboardFrame(_ notification: NSNotification) {
        guard isViewLoaded,
              let info = notification.userInfo,
              let keyboardValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        let padding: CGFloat = Constant.overlayVerticalPadding
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.overlayBottomConstraint?.constant = -padding
        } else {
            self.overlayBottomConstraint?.constant = -(keyboardViewEndFrame.height + padding)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MainContainerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Pick the location with best (= smallest value) horizontal accuracy
        if let location = locations.sorted(by: { $0.horizontalAccuracy < $1.horizontalAccuracy }).first {
            guard coordinate?.latitude == location.coordinate.latitude, coordinate?.longitude == location.coordinate.longitude else {
                coordinate = location.coordinate
                return
            }
            // stop updating once we've found a good coordinate
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authStatusChanged(status: status)
    }
}

extension MainContainerViewController: OverlayViewDelegate {
    func buttonTapped() {
        if viewType == .map {
            viewType = .list
            displayListController()
        } else {
            viewType = .map
            displayMapController()
        }
        overlayView.configure(with: viewType)
    }
}

extension MainContainerViewController: SearchViewDelegate {
    func filterButtonTapped() {
        print("filterButtonTapped")
    }

    func searchTextChanged(_ text: String) {
        guard text.count > 3 else { return }
        var locationText: String?
        if let coordinate = coordinate {
            locationText = "\(coordinate.latitude),\(coordinate.longitude)"
        }
        let searchQuery = PlacesSearchHandler(queryText: text, locationText: locationText)
        searchQuery.performQuery { places, error in
            self.placeData = places
        }
    }
}

