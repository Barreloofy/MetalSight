//
// Configuration+Preset.swift
// MetalSight
//
// Created by Barreloofy on 12/18/25 at 5:55 PM
//

extension Configuration {
  static var fpsOnly: Set<String> {
    ["fps"]
  }

  static var `default`: Set<String> {
    [
      "device",
      "rosetta",
      "layersize",
      "memory",
      "gamemode",
      "fps",
      "gputime",
      "frameinterval",
      "frameintervalgraph",
    ]
  }

  static var rich: Set<String> {
    [
      "device",
      "rosetta",
      "layersize",
      "memory",
      "thermal",
      "gamemode",
      "fps",
      "gputime",
      "presentdelay",
      "frameinterval",
      "frameintervalgraph",
      "metalcpu",
      "shaders"
    ]
  }

  static var full: Set<String> {
    [
      "device",
      "rosetta",
      "layersize",
      "layerscale",
      "memory",
      "refreshrate",
      "thermal",
      "gamemode",
      "fps",
      "framenumber",
      "gputime",
      "presentdelay",
      "frameinterval",
      "frameintervalgraph",
      "frameintervalhistogram",
      "metalcpu",
      "shaders",
      "gputimeline",
    ]
  }
}
