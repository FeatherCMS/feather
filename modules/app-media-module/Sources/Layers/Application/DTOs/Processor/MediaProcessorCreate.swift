//
//  MediaProcessorCreate.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct MediaProcessorCreate: DTO {
    public let name: String
    public let matchExtensions: String
    public let commandTemplate: String

    public init(name: String, matchExtensions: String, commandTemplate: String)
    {
        self.name = name
        self.matchExtensions = matchExtensions
        self.commandTemplate = commandTemplate
    }
}
