// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import Combine
import GoogleMapsPlatformCombine
import GoogleMaps
import GooglePlaces
import UIKit

class ViewController: UIViewController {

    private var publisher: GMSMapViewPublisher!
    private var subscriptions: Set<AnyCancellable> = []

    private let sydneyLatitude: Double = -33.86
    private let sydneyLongitude: Double = 151.20
    private let markerTitle: String = "Sydney"
    private let markerSnippet: String = "Australia"

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView: GMSMapView = createGMSCameraPositionAndMapView()
        setupGMSMapView(mapView: mapView)
        createGMSMarkerInTheCenterOfTheMap(mapView: mapView)
        startAndEndMapsCombinePublisher(mapView: mapView)
    }

    /// Create a GMSCameraPosition that tells the map to display the coordinate -33.86,151.20 at zoom level 6.
    /// - Returns: GMSMapView
    private func createGMSCameraPositionAndMapView() -> GMSMapView {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: sydneyLatitude, longitude: sydneyLongitude, zoom: 6.0)
        let mapView: GMSMapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        return mapView
    }

    /// Setup GMSMapView
    /// - Parameter mapView: GMSMapView
    private func setupGMSMapView(mapView: GMSMapView) {
        view.addSubview(mapView)
    }

    /// Creates a marker in the center of the map.
    /// - Parameter mapView: GMSMapView
    private func createGMSMarkerInTheCenterOfTheMap(mapView: GMSMapView) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: sydneyLatitude, longitude: sydneyLongitude)
        marker.title = markerTitle
        marker.snippet = markerSnippet
        marker.map = mapView
    }

    /// Start and End Maps iOS combine publisher camera change position
    /// - Parameter mapView: GMSMapView
    private func startAndEndMapsCombinePublisher(mapView: GMSMapView) {
        // [START maps_ios_combine_publisher_camera_change_position]
        let publisher = GMSMapViewPublisher(mapView: mapView)
        publisher.didChangeCameraPosition.sink { cameraPosition in
            print("Camera position at \(cameraPosition.target)")
        }
        // [END maps_ios_combine_publisher_camera_change_position]
        .store(in: &subscriptions)

        self.publisher = publisher
    }

    private func fetchPlaceSample() {
        // [START maps_ios_combine_future_fetch_place]
        GMSPlacesClient.shared()
          .fetchPlace(
            id: "placeId",
            fields: [.placeID, .name, .phoneNumber]
          )
          .sink { completion in
            print("Completion \(completion)")
          } receiveValue: { place in
            print("Got place \(place.name ?? "")")
          }
        // [END maps_ios_combine_future_fetch_place]

          .store(in: &subscriptions)
    }
}

