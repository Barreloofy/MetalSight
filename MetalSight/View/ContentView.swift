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

  @AppStorage("metrics") private var metrics: Set<String> = []
  @AppStorage("metricsModifier") private var metricsModifier: Dictionary<String, Int> = [
    "MTL_HUD_ENCODER_GPU_TIMELINE_FRAME_COUNT": 6,
    "MTL_HUD_ENCODER_GPU_TIMELINE_SWAP_DELTA": 1,
    "MTL_HUD_RUSAGE_UPDATE_INTERVAL": 3,
  ]

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
            metrics: $metrics,
            metricsModifier: $metricsModifier)
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
    .onChange(of: metricsModifier) {
      _ = metricsModifier.reduce(into: [String]()) { result, element in
        result.append(element.key)
        result.append(String(element.value))
      }
    }
  }
}


#Preview {
  ContentView()
    .scenePadding()
}
