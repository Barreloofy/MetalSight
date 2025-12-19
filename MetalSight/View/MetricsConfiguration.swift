//
// MetricsConfiguration.swift
// MetalSight
//
// Created by Barreloofy on 12/12/25 at 5:00 PM
//

import SwiftUI

struct MetricsConfiguration: View {
  @Binding
  var metrics: Set<String>
  @Binding
  var metricsModifier: Dictionary<String, Int>

  @AppStorage("preset")
  private var preset: MetricsPreset = .custom

  private func selection(for key: String, default defaultValue: Int) -> Binding<Int> {
    Binding {
      guard
        metricsModifier[key] == nil
      else { return metricsModifier[key]! }

      metricsModifier[key] = defaultValue

      return defaultValue
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
      preset = .custom
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
          selection: selection(for: "MTL_HUD_ENCODER_GPU_TIMELINE_FRAME_COUNT", default: 6)) {
            ForEach(1...6, id: \.self) { count in
              Text(count.description)
            }
          }
          .help("The maximum number of frames that appear in the GPU timeline")

        Picker(
          "GPU Timeline Update Interval",
          selection: selection(for: "MTL_HUD_ENCODER_GPU_TIMELINE_SWAP_DELTA", default: 1)) {
            ForEach([1, 15, 30, 45, 60], id: \.self) { interval in
              Text(interval.description)
            }
          }
          .help("The update interval of the GPU timeline in seconds")

        Picker(
          "System Resource Update Interval",
          selection: selection(for: "MTL_HUD_RUSAGE_UPDATE_INTERVAL", default: 3)) {
            ForEach([1, 3, 15, 30 , 45, 60], id: \.self) { interval in
              Text(interval.description)
            }
          }
          .help("The system resource usage update interval in seconds")
      }
      .listRowSeparator(.hidden)

      Section {
        Picker("Preset", selection: $preset) {
          ForEach(MetricsPreset.allCases) { preset in
            Text(preset.rawValue)
          }
        }
        .onChange(of: preset) {
          switch preset {
          case .default:
            metrics = Configuration.default
          case .fpsOnly:
            metrics = Configuration.fpsOnly
          case .rich:
            metrics = Configuration.rich
          case .full:
            metrics = Configuration.full
          case .custom:
            break
          }
        }
      }
      .listRowSeparator(.hidden)

      Section {
        ForEach(MetalHUDMetrics.allCases) { metric in
          Form {
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
  @Previewable @State
  var metrics = Set<String>()
  @Previewable @State
  var metricsModifier = Dictionary<String, Int>()

  MetricsConfiguration(
    metrics: $metrics,
    metricsModifier: $metricsModifier)
}
