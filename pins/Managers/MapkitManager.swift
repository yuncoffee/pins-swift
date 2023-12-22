//
//  MapManager.swift
//  pins
//
//  Created by yuncoffee on 12/19/23.
//

import Foundation
import MapKit

@Observable
final class MapkitManager: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter = .init()
}


extension CLLocationCoordinate2D {
    static let devHouse = CLLocationCoordinate2D(latitude: 37.818893, longitude: 127.100640)
    static let devHouse2 = CLLocationCoordinate2D(latitude: 37.818893, longitude: 127.100682)
}
