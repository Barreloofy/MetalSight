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

  @State private var placementIsExpanded = false
  @State private var placement: AlignmentConfiguration = .topright

  @State private var metricsIsExpanded = false
  @State private var metrics: Set<String> = []

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      MetalHud(enabled: $enabled)

      FailureView(failed: failure)
        .padding(.top)

      List {
        Section("Placement", isExpanded: $placementIsExpanded) {
          Picker("", selection: $placement) {
            ForEach(AlignmentConfiguration.allCases) { placement in
              Text(placement.rawValue)
            }
          }
          .pickerStyle(.inline)
        }
        .onTapGesture {
          placementIsExpanded.toggle()
        }

        Section("Metrics", isExpanded: $metricsIsExpanded) {
          ForEach(ElementConfiguration.allCases) { metric in
            Toggle(
              metric.rawValue,
              isOn: Binding {
                metrics.contains(metric.description)
              } set: { newValue in
                if newValue {
                  metrics.insert(metric.description)
                } else {
                  metrics.remove(metric.description)
                }
              })
          }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.leading, 10)
        .onTapGesture {
          metricsIsExpanded.toggle()
        }
      }
      .listStyle(.plain)
      .scrollIndicators(.never)

      Button("Quit", systemImage: "power.circle") {
        NSApp.terminate(nil)
      }
      .buttonStyle(.bordered)
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
            arguments: ["setenv", "MTL_HUD_ENABLED", "1", "MTL_HUD_ELEMENTS", metrics.joined(separator: ",")])
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
