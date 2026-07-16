//
//  MediaApplicationTests.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Testing

@testable import MediaApplication

@Test("MediaApplication loads")
func mediaApplicationLoads() {
    _ = MediaApplicationModule.self
}
