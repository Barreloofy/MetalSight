//
// ContentView.swift
// MetalSight
//
// Created by Barreloofy on 11/30/25 at 10:36 PM
//

import SwiftUI

struct ContentView: View {
  @State private var enabled = false
  @State private var failure = false

  var body: some View {
    VStack(alignment: .leading) {
      Toggle("Enable Metal HUD", isOn: $enabled)
        .toggleStyle(.switch)

      Text("Relaunch Crossover, Steam, game to apply")
        .font(.footnote)

      FailureView(failed: failure)
        .padding(.top)

      Button("Quit", systemImage: "power.circle") {
        NSApp.terminate(nil)
      }
      .buttonStyle(.plain)
      .padding(.top)
    }
    .onAppear {
      do {
        let process = Process()
        process.executableURL = URL(filePath: "/bin/launchctl")
        process.arguments = ["getenv", "MTL_HUD_ENABLED"]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()

        guard
          let data = try pipe.fileHandleForReading.readToEnd(),
          let rawValue = String(data: data, encoding: .utf8),
          let rawValueAsInt = Int(rawValue.trimmingCharacters(in: .whitespacesAndNewlines)),
          let isEnabled = Bool(exactly: rawValueAsInt as NSNumber)
        else { return }

        enabled = isEnabled
        failure = false
      } catch {
        failure = true
      }
    }
    .onChange(of: enabled) {
      do {
        if enabled {
          let _ = try Process.run(
            URL(filePath: "/bin/launchctl"),
            arguments: ["setenv", "MTL_HUD_ENABLED", "1"])
        } else {
          let _ = try Process.run(
            URL(filePath: "/bin/launchctl"),
            arguments: ["unsetenv", "MTL_HUD_ENABLED"])
        }
        failure = false
      } catch {
        failure = true
      }
    }
  }
}


#Preview {
  ContentView()
    .scenePadding()
}
