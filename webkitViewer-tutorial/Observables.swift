//
//  Observables.swift
//  webkitViewer-tutorial
//
//  Created by Jeevanjot Singh on 17/05/25.
//

import Foundation
import SwiftData

@Model
class FavouritesList {
    @Attribute(.unique) var favouriteUrl: URL
    
    init(favouriteUrl: URL) {
        self.favouriteUrl = favouriteUrl
    }
}

@Observable class Observables {
    var estimatedProgress: Double = 0
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    var searchUrl: String = ""
    var sharableLink: URL?
    var countedSoFar: Int = 1
    var isFavourite: Bool = false
}

class ObservablePropertiesTokens: NSObject {
    static var estimatedProgressObservationToken: NSKeyValueObservation?
    static var canGoBackObservationToken: NSKeyValueObservation?
    static var canGoForwardObservationToken: NSKeyValueObservation?
    static var urlChangedObservationToken: NSKeyValueObservation?
}
