//
// ContentView.swift
// MetalSight
//
// Created by Barreloofy on 11/30/25 at 10:36 PM
//

import SwiftUI

struct ContentView: View {
  @State private var enabled = false

  @AppStorage("placement") private var placement: HUDPlacement = .topright
  @AppStorage("scale") private var scale = 0.2

  @AppStorage("metricsModifier") private var metricsModifier: Set<String> = []
  @AppStorage("metrics") private var metrics: Set<String> = []
  @AppStorage("metricsModifierAdditional") var metricsModifierAdditional: Dictionary<String, Int> = [:]

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      MetalHUD(enabled: $enabled)

      TabView {
        Tab {
          HUDView(
            placement: $placement,
            scale: $scale)
        } label: {
          Text("HUD")
        }

        Tab {
          MetricsView(
            metricsModifier: $metricsModifier,
            metrics: $metrics,
            metricsModifierAdditional: $metricsModifierAdditional)
        } label: {
          Text("Metrics")
        }
      }

      Button("Quit", systemImage: "power.circle") {
        NSApp.terminate(nil)
      }
      .buttonStyle(.bordered)
    }
    .onAppear {
      let process = Process()
      process.executableURL = URL(filePath: "/bin/launchctl")
      process.arguments = ["getenv", "MTL_HUD_ENABLED"]

      let pipe = Pipe()
      process.standardOutput = pipe

      guard
        let _ = try? process.run(),
        let data = try? pipe.fileHandleForReading.readToEnd(),
        let rawValue = String(data: data, encoding: .utf8),
        let rawValueAsInt = Int(rawValue.trimmingCharacters(in: .whitespacesAndNewlines)),
        let isEnabled = Bool(exactly: rawValueAsInt as NSNumber)
      else { return }

      enabled = isEnabled
    }
    .onChange(of: enabled) {
      if enabled {
        _ = try? Process.run(
          URL(filePath: "/bin/launchctl"),
          arguments: [
            "setenv",
            "MTL_HUD_ENABLED",
            "1",
            "MTL_HUD_DISABLE_MENU_BAR",
            "1",
            "MTL_HUD_ALIGNMENT",
            placement.description,
            "MTL_HUD_SCALE",
            scale.description,
            "MTL_HUD_ELEMENTS",
            metrics.joined(separator: ",")])
      } else {
        _ = try? Process.run(
          URL(filePath: "/bin/launchctl"),
          arguments: ["unsetenv", "MTL_HUD_ENABLED"])
      }
    }
  }
}


#Preview {
  ContentView()
    .scenePadding()
}
