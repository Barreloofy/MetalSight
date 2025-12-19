//
// MetricsPreset.swift
// MetalSight
//
// Created by Barreloofy on 12/19/25 at 6:15 PM
//

enum MetricsPreset: String, Identifiable, CaseIterable {
  case `default` = "Default"
  case fpsOnly = "FPS Only"
  case rich = "Rich"
  case full = "Full"
  case custom = "Custom"

  var id: Self {
    self
  }
}
