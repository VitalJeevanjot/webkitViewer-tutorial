//
//  Observables.swift
//  webkitViewer-tutorial
//
//  Created by Jeevanjot Singh on 17/05/25.
//

import Foundation

@Observable class Observables {
    var estimatedProgress: Double = 0
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    var searchUrl: String = ""
    var sharableLink: URL?
}

class ObservablePropertiesTokens: NSObject {
    static var estimatedProgressObservationToken: NSKeyValueObservation?
    static var canGoBackObservationToken: NSKeyValueObservation?
    static var canGoForwardObservationToken: NSKeyValueObservation?
    static var urlChangedObservationToken: NSKeyValueObservation?
}
