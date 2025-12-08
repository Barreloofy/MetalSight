//
// Configuration.swift
// MetalSight
//
// Created by Barreloofy on 12/8/25 at 4:57 PM
//

import Foundation

enum Configuration {
  case MTL_HUD_LOG_ENABLED
  case MTL_HUD_LOG_SHADER_ENABLED
  case MTL_HUD_OPACITY
  case MTL_HUD_SCALE
  case MTL_HUD_ALIGNMENT
  case MTL_HUD_POSITION_X
  case MTL_HUD_POSITION_Y
  case MTL_HUD_ELEMENTS
  case MTL_HUD_ENCODER_TIMING_ENABLED
  case MTL_HUD_ENCODER_GPU_TIMELINE_FRAME_COUNT
  case MTL_HUD_ENCODER_GPU_TIMELINE_SWAP_DELTA
  case MTL_HUD_SHOW_ZERO_METRICS
  case MTL_HUD_SHOW_METRICS_RANGE
  case MTL_HUD_INSIGHTS_ENABLED
  case MTL_HUD_INSIGHT_TIMEOUT
  case MTL_HUD_DISABLE_MENU_BAR
}


enum ElementConfiguration {
  case device
  case rosetta
  case layersize
  case layerscale
  case memory
  case fps
  case frameinterval
  case gputime
  case thermal
  case frameintervalgraph
  case presentdelay
  case frameintervalhistogram
  case metalcpu
  case gputimeline
  case shaders
  case framenumber
  case disk
  case fpsgraph
  case toplabeledcommandbuffers
  case toplabeledencoders
}


enum AlignmentConfiguration {
  case topleft
  case topcenter
  case topright
  case centerleft
  case centered
  case centerright
  case bottomright
  case bottomcenter
  case bottomleft
}

/*
 MTL_HUD_LOG_ENABLED=1
 Turns on logging for per-frame statistics.

 MTL_HUD_LOG_SHADER_ENABLED=1
 Turns on logging for shader compilation activities.

 MTL_HUD_CONFIG_FILE=<path>
 Selects a configuration file the Metal HUD loads, which needs to be the file path the app can access.

 MTL_HUD_OPACITY=1.0
 Configures the opacity of the overlay in the range [0.0, 1.0]. The default value is 1.0.

 MTL_HUD_SCALE=0.2
 Configures the scale of the overlay as a percentage of the drawable width in the range [0.0, 1.0]. The default scale is 0.2 with a minimum width of 300 pixels.

 MTL_HUD_ALIGNMENT=topright
 Sets the position of the overlay. The default position is topright. Available options are topleft, topcenter, topright, centerleft, centered, centerright, bottomright, bottomcenter, and bottomleft.

 MTL_HUD_POSITION_X, MTL_HUD_POSITION_Y
 Sets the absolute position of the overlay in pixels. Overrides MTL_HUD_ALIGNMENT.

 MTL_HUD_ELEMENTS
 Specifies a comma-separated list of metrics that appears in the overlay. Available metric names are device, rosetta, layersize, layerscale, memory, fps, frameinterval, gputime, thermal, frameintervalgraph, presentdelay, frameintervalhistogram, metalcpu, gputimeline, shaders, framenumber, disk, fpsgraph, toplabeledcommandbuffers, and toplabeledencoders. See Understanding the Metal Performance HUD metrics for more information.

 MTL_HUD_ENCODER_TIMING_ENABLED=1
 Turns on encoder-based GPU time tracking. See Understand encoder GPU time tracking for more information.

 MTL_HUD_ENCODER_GPU_TIMELINE_FRAME_COUNT=6
 Sets the maximum number of frames that appear in the GPU timeline.

 MTL_HUD_ENCODER_GPU_TIMELINE_SWAP_DELTA=1
 Sets the update interval of the GPU timeline in seconds.

 MTL_HUD_SHOW_ZERO_METRICS=1
 Makes the overlay show that metrics have a value of 0 since the app launched or since the last reset. The Metal Performance HUD enables this variable by default to hide metrics that may not be available or aren’t used in the current context.

 MTL_HUD_SHOW_METRICS_RANGE=1
 Reports the range of metrics for the last 1200 frames. See Display the value range of metrics for more information.
 MTL_HUD_INSIGHTS_ENABLED=1
 Turns on the performance insights feature. See Gaining performance insights with the Metal Performance HUD for more information.

 MTL_HUD_INSIGHT_TIMEOUT=10
 Sets the performance insight timeout before it dissapears.

 MTL_HUD_INSIGHT_REPORT_INTERVAL=5
 Sets the report interval of the performance insights in seconds. The Metal Performance HUD reports performance insights if half of the frames during this interval show a particular pattern.

 MTL_HUD_RUSAGE_UPDATE_INTERVAL=3
 Sets the system resource usage update interval in seconds.

 MTL_HUD_METRIC_TIMEOUT=5
 Sets the timeout of transient metrics in seconds. The Metal Performance HUD automatically hides transient metrics, such as MetalFX metrics, when you disable MetalFX.

 MTL_HUD_REPORT_URL=\<path>
 Sets an app writable path where the system writes performance reports to. See Generating performance reports with the Metal Performance HUD for more information.

 MTL_HUD_DISABLE_MENU_BAR=1
 Disables the Metal Performance HUD menu item.
 */
