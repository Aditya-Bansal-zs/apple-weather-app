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

    private var hasResolvedLocation = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestPermission()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("Location permission not granted.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !hasResolvedLocation, let location = locations.last else { return }

        hasResolvedLocation = true
        locationManager.stopUpdatingLocation()
        userLocation = location
        print(" Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getCityAndCountry(from: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(" Location update failed: \(error.localizedDescription)")
    }

    private func getCityAndCountry(from location: CLLocation) {
        print("Attempting reverse geocode for: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(" Reverse geocoding failed: \(error.localizedDescription)")
                // Fallback values
                DispatchQueue.main.async {
                    self.city = "Bengaluru"
                    self.country = "India"
                }
                return
            }

            guard let placemark = placemarks?.first else {
                print(" No placemarks found.")
                DispatchQueue.main.async {
                    self.city = "Bengaluru"
                    self.country = "India"
                }
                return
            }

            DispatchQueue.main.async {
                self.city = placemark.locality ?? "Bengaluru"
                self.country = placemark.country ?? "India"
                print(" Resolved location: \(self.city), \(self.country)")
            }
        }
    }
}
