//
// FailureView.swift
// MetalSight
//
// Created by Barreloofy on 12/1/25 at 10:05 PM
//

import SwiftUI

struct FailureView: View {
  let failed: Bool

  var body: some View {
    if failed {
      Label(
        "Failed to apply setting",
        systemImage: "exclamationmark.triangle")
    }
  }
}
