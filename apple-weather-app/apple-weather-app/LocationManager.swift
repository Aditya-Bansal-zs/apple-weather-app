//
//  LocationManager.swift
//  apple-weather-app
//
//  Created by ZopSmart on 02/04/25.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var userLocation: CLLocation?
    @Published var city: String = ""
    @Published var country: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestPermission()
    }

    /// Request location permission
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    /// CLLocationManager Delegate: Updates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location
            self.getCityAndCountry(from: location)
        }
    }

    /// Reverse Geocode: Get City & Country from Coordinates
    private func getCityAndCountry(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.city = placemark.locality ?? "Unknown City"
                    self.country = placemark.country ?? "Unknown Country"
                }
            }
        }
    }
}

