//
//  MapView.swift
//  SciflareTask
//
//  Created by Chandru on 29/05/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $position){
            UserAnnotation()
        }
        .ignoresSafeArea()
        .mapControls({
            MapUserLocationButton()
            MapPitchToggle()
        })
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}
