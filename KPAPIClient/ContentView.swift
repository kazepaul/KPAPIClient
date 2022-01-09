//
//  ContentView.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/13.
//

import SwiftUI

enum SampleAPIList: String, CaseIterable {
    case KanaKanjiAPI
    case RubyFuriAPI
    
    func sampleViewForAPI() -> some View {
        switch self {
        case .KanaKanjiAPI:
            return AnyView(KanaKanjiAPISampleView())
        case .RubyFuriAPI:
            return AnyView(RubyFuriAPISampleView())
        }
    }
}

struct ContentView: View {
    @State private var navigationToAppInfoView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(SampleAPIList.allCases, id: \.self) {
                    NavigationLink($0.rawValue, destination: $0.sampleViewForAPI)
                }
            }
            .navigationBarTitle("KPAPIClient Sample App", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
