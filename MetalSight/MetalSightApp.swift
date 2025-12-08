//
// MetalSightApp.swift
// MetalSight
//
// Created by Barreloofy on 11/30/25 at 10:36 PM
//

import SwiftUI

@main
struct MetalSightApp: App {
  var body: some Scene {
    MenuBarExtra("Metal Sight", systemImage: "gamecontroller") {
      ContentView()
        .scenePadding()
    }
    .menuBarExtraStyle(.window)
  }
}
