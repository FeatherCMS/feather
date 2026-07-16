//
//  MediaDomainTests.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Testing

@testable import MediaDomain

@Test("MediaDomain loads")
func mediaDomainLoads() {
    _ = MediaDomainModule.self
}
