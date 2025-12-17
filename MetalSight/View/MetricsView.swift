//
// MetricsView.swift
// MetalSight
//
// Created by Barreloofy on 12/12/25 at 5:00 PM
//

import SwiftUI

struct MetricsView: View {
  @Binding var metrics: Set<String>
  @Binding var metricsModifier: Dictionary<String, Int>

  private func selection(for key: String) -> Binding<Int> {
    Binding {
      metricsModifier[key]!
    } set: { newValue in
      metricsModifier[key] = newValue
    }
  }

  private func isOn(for key: String) -> Binding<Bool> {
    Binding {
      metricsModifier[key] == 1
    } set: { newValue in
      metricsModifier[key] = newValue ? 1 : 0
    }
  }

  private func isOn(for value: MetalHUDMetrics) -> Binding<Bool> {
    Binding {
      metrics.contains(value.description)
    } set: { newValue in
      if newValue {
        metrics.insert(value.description)
      } else {
        metrics.remove(value.description)
      }
    }
  }

  var body: some View {
    List {
      Section {
        Toggle(
          "Show Value Range",
          isOn: isOn(for: "MTL_HUD_SHOW_METRICS_RANGE"))

        Toggle(
          "Show Metrics With 0 Value",
          isOn: isOn(for: "MTL_HUD_SHOW_ZERO_METRICS"))

        Toggle(
          "Encoder GPU Time Tracking",
          isOn: isOn(for: "MTL_HUD_ENCODER_TIMING_ENABLED"))
        Label("Increases CPU usage", systemImage: "exclamationmark.triangle.fill")
          .symbolRenderingMode(.multicolor)
          .listRowInsets(.leading, 25)
      }
      .listRowSeparator(.hidden)

      Section {
        Picker(
          "GPU Timeline Frame Range",
          selection: selection(for: "MTL_HUD_ENCODER_GPU_TIMELINE_FRAME_COUNT")) {
            ForEach(1...6, id: \.self) { count in
              Text(count.description)
            }
          }

        Picker(
          "GPU Timeline Update Interval",
          selection: selection(for: "MTL_HUD_ENCODER_GPU_TIMELINE_SWAP_DELTA")) {
            ForEach([1, 15, 30, 45, 60], id: \.self) { interval in
              Text(interval.description)
            }
          }

        Picker(
          "System Resource Update Interval",
          selection: selection(for: "MTL_HUD_RUSAGE_UPDATE_INTERVAL")) {
            ForEach([1, 3, 15, 30 , 45, 60], id: \.self) { interval in
              Text(interval.description)
            }
          }
      }
      .listRowSeparator(.hidden)

      Section {
        ForEach(MetalHUDMetrics.allCases) { metric in
          VStack(alignment: .leading) {
            Toggle(
              metric.rawValue,
              isOn: isOn(for: metric))
            if metric.requiresEncoderGPUTimeTracking {
              Label(
                "Requires Encoder GPU Time Tracking",
                systemImage: "exclamationmark.triangle.fill")
              .symbolRenderingMode(.multicolor)
              .offset(x: 25)
            }
          }
        }
      }
      .listRowSeparator(.hidden)
    }
  }
}


#Preview {
  MetricsView(
    metrics: .constant([]),
    metricsModifier: .constant([:]))
}
