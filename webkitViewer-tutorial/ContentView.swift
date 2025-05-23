//
//  ContentView.swift
//  webkitViewer-tutorial
//
//  Created by Jeevanjot Singh on 14/05/25.
//

import SwiftUI
import SwiftData
import WebKit
import UIKit

struct ContentView: View {
    @State private var customWebView = CustomWebView().setupView()
    @State var observables = Observables()
    @State private var showSheet = false
    
    @Environment(\.modelContext) private var context
    @Query var allFavourites: [FavouritesList]
    
    let getFile = Bundle.main.url(forResource: "Simple", withExtension: "html")
    
    
    var colorMaroon = Color(red: 100/255, green: 20/255, blue: 50/255)
    var colorTextField = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    
    var SIMD2Points2nd: [SIMD2<Float>] =
    [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1)
    ]
    
    var colorsInMeshGradientPoints2nd: [Color] = [
        .red, .orange, .red,
        .orange, .green, .blue,
        .yellow, .red, .mint
    ]
    
    @State var textfieldValueBinding = ""
    
    var body: some View {
        VStack(spacing: 0) {
            CustomWebKitView(webView: customWebView, observablesClass: observables)
            
            VStack(spacing: 0) {
                TextFieldView(searchField: $observables.searchUrl, estimatedProgress: $observables.estimatedProgress).padding(.bottom, 10).onSubmit {
                    if observables.searchUrl.isEmpty{return}
                    if observables.searchUrl == customWebView.url?.absoluteString {return}
                    if observables.searchUrl == "Simple.html" {return}
                    var sField = observables.searchUrl.lowercased()
                    if !sField.contains("://")
                    {
                        if sField.contains("localhost") || sField.contains("127.0.0.1")
                        {
                            sField = "http://" + sField
                        } else
                        {
                            if sField.contains(".") {
                                sField = "https://" + sField
                            } else {
                                sField =  "https://search.yahoo.com/search?ei=utf-8&fr=aaplw&p=\(sField)"
                            }
                        }
                    }
                    let urlToLoad = URL(string: sField)!
                    customWebView.load(URLRequest(url: urlToLoad))
                }
                
                HStack {
                    Button {
                        customWebView.goBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(observables.canGoBack ? .white : .white.opacity(0.5))
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .disabled(!observables.canGoBack)
                    Spacer()
                    
                    Button {
                        customWebView.goForward()
                    } label: {
                        Label("Forward", systemImage: "chevron.right")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(observables.canGoForward ? .white : .white.opacity(0.5))
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .disabled(!observables.canGoForward)
                    Spacer()
                    
                    Button {
                        runSimpleJSFunction()
                    } label: {
                        HStack (spacing: 0) {
                            Label("Add 1", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .foregroundStyle((observables.searchUrl == "Simple.html") ? .white : .white.opacity(0.5))
                                .font(.system(size: 20))
                            VStack(spacing: 0) {
                                Text("\(observables.countedSoFar)").foregroundStyle(.white)
                                Spacer()
                            }
                        }
                        .frame(width: 30, height: 30)
                        
                    }
                    .disabled(!(observables.searchUrl == "Simple.html"))
                    Spacer()
                    
                    Button {
                        if let url = customWebView.url {
                            if !observables.isFavourite {
                                let newFav = FavouritesList(favouriteUrl: url)
                                context.insert(newFav)
                                observables.isFavourite = true
                            } else {
                                let predicate = #Predicate<FavouritesList> {
                                    fav in fav.favouriteUrl == url
                                }
                                
                                try? context.delete(model: FavouritesList.self, where: predicate)
                                
                                observables.isFavourite = false
                            }
                            try? context.save()
                        }
                    } label: {
                        Label("Favourite", systemImage: observables.isFavourite ? "star.fill" : "star")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                    
                    ShareLink(item: observables.sharableLink ?? URL(string: "https://www.apple.com")!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    Button {
                        showSheet = true
                    } label: {
                        VStack(spacing: 0) {
                            Label("Favourites", systemImage: "star.fill")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.white)
                                .font(.system(size: 10))
                            Label("Favourites", systemImage: "line.3.horizontal")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                        }
                        .frame(width: 30, height: 30)
                    }
                }
                .padding([.horizontal], 5)
                .padding(.bottom, 35)
            }
            .padding([.horizontal])
            .background(MeshGradient(width: 3, height: 3, points: SIMD2Points2nd, colors: colorsInMeshGradientPoints2nd))
        }
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
        .sheet(isPresented: $showSheet) {
            Text("Favourites").font(.title)
            List(allFavourites) { fav in
                if fav.favouriteUrl.scheme == "file" {
                    Text(fav.favouriteUrl.lastPathComponent)
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            customWebView.loadFileURL(getFile!, allowingReadAccessTo: getFile!)
                            showSheet = false
                        }
                } else {
                    Text(fav.favouriteUrl.absoluteString)
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            customWebView.load(URLRequest(url: fav.favouriteUrl))
                            showSheet = false
                        }
                }
            }
        }
    }
    
    func runSimpleJSFunction() {
        customWebView.evaluateJavaScript("addMore(\(observables.countedSoFar))") { obj, err in
            if let err = err {
                print(err)
            }
        }
    }
    
}

struct CustomWebKitView: UIViewRepresentable {
    var webView: WKWebView!
    var observablesClass: Observables
    @Query var allFavourites: [FavouritesList]
    
    
    
    func makeUIView(context: Context) -> WKWebView {
        let getFile = Bundle.main.url(forResource: "Simple", withExtension: "html")
        //        let myURL = URL(string: "https://apple.com")
        //        let myRequest = URLRequest(url: myURL!)
        let userContentController = WKUserContentController()
        let customScriptMsgHandler = CustomWKScriptMessageHandler(observables: observablesClass)
        webView.navigationDelegate = customScriptMsgHandler
        webView.configuration.userContentController = userContentController
        webView.configuration.userContentController.add(customScriptMsgHandler, name: "IncrementFunction")
        
        ObservablePropertiesTokens.estimatedProgressObservationToken = webView.observe(\.estimatedProgress) {
            (object, change) in
            observablesClass.estimatedProgress =  object.estimatedProgress
        }
        
        ObservablePropertiesTokens.canGoBackObservationToken = webView.observe(\.canGoBack) {
            (object, change) in
            observablesClass.canGoBack =  object.canGoBack
        }
        
        ObservablePropertiesTokens.canGoForwardObservationToken = webView.observe(\.canGoForward) {
            (object, change) in
            observablesClass.canGoForward =  object.canGoForward
        }
        
        ObservablePropertiesTokens.urlChangedObservationToken = webView.observe(\.url) {
            (object, change) in
            if let url = object.url {
                observablesClass.sharableLink = url
                if url.scheme == "file" {
                    observablesClass.searchUrl = "Simple.html"
                } else {
                    observablesClass.searchUrl = url.absoluteString
                }
                
                if allFavourites.contains(where: { FavouritesList in
                    FavouritesList.favouriteUrl == url
                }) {
                    observablesClass.isFavourite = true
                } else {
                    observablesClass.isFavourite = false
                }
            }
        }
        
        webView.loadFileURL(getFile!, allowingReadAccessTo: getFile!)
        //        webView.load(myRequest)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    
}

class CustomWKScriptMessageHandler: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
    var observables: Observables
    
    init(observables: Observables) {
        self.observables = observables
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "IncrementFunction" {
            if message.body as! String == "add1" {
                observables.countedSoFar += 1
            }
        }
    }
    
}


class CustomWebView: NSObject, WKNavigationDelegate {
    var webView: WKWebView!
    var canGoBackObservationToken: NSKeyValueObservation?
    var canGoForwardObservationToken: NSKeyValueObservation?
    var estimatedProgress: Double = 0.0
    
    func setupView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Sample-App-Solana_wallet"
        configuration.allowsInlineMediaPlayback = true
        configuration.dataDetectorTypes = [.link, .calendarEvent]
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isInspectable = true
        return webView
    }
    
    
    //      Web page started to receive content for main frame
    //    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    //    }
}

#Preview {
    NavigationStack {
        ContentView()
            .modelContainer(for: [FavouritesList.self], inMemory: true)
    }
}
