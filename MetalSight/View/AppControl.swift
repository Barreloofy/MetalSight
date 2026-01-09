//
// AppControl.swift
// MetalSight
//
// Created by Barreloofy on 12/18/25 at 1:59 PM
//

import SwiftUI
import ServiceManagement

struct AppControl: View {
  @Environment(\.appearsActive) private var appearsActive

  @State private var launchAtLogin = false

  var body: some View {
    HStack {
      Button("Quit", systemImage: "power.circle", role: .close) {
        NSApp.terminate(nil)
      }
      .tint(.red)

      Spacer()

      Toggle("Launch At Login", isOn: $launchAtLogin)
    }
    .onChange(of: appearsActive, initial: true) {
      if SMAppService.mainApp.status == .enabled {
        launchAtLogin = true
      } else {
        launchAtLogin = false
      }
    }
    .onChange(of: launchAtLogin) {
      if launchAtLogin {
        try? SMAppService.mainApp.register()
      } else {
        try? SMAppService.mainApp.unregister()
      }
    }
  }
}


#Preview {
  AppControl()
}
