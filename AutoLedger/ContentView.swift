//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        MacContentView()
        #else
        IOSContentView()
        #endif
    }
}

#Preview {
    ContentView()
}
