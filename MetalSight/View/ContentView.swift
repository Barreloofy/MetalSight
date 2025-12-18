//
// ContentView.swift
// MetalSight
//
// Created by Barreloofy on 11/30/25 at 10:36 PM
//

import SwiftUI

struct ContentView: View {
  @State
  private var enabled = false

  @CodableStorage("configuration")
  private var configuration = Configuration()

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HUDControl(enabled: $enabled)

      TabView {
        Tab {
          HUDConfiguration(
            placement: $configuration.placement,
            scale: $configuration.scale)
        } label: {
          Text("HUD")
        }

        Tab {
          MetricsConfiguration(
            metrics: $configuration.metrics,
            metricsModifier: $configuration.metricsModifier)
        } label: {
          Text("Metrics")
        }
      }

      AppControl()
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
          arguments: configuration.asArguments)
      } else {
        _ = try? Process.run(
          URL(filePath: "/bin/launchctl"),
          arguments: ["unsetenv", "MTL_HUD_ENABLED"])
      }
    }
    .task(id: configuration) {
      guard
        enabled == true,
        let _ = try? await Task.sleep(for: .seconds(0.5))
      else { return }

      _ = try? Process.run(
        URL(filePath: "/bin/launchctl"),
        arguments: configuration.asArguments)
    }
  }
}


#Preview {
  ContentView()
    .scenePadding()
}
