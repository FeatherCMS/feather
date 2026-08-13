//
//  MenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct PublicMenuItem: DTO {
    public let id: String
    public let label: String
    public let url: String
    public let priority: Int
    public let isBlank: Bool

    public init(
        id: String,
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool
    ) {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
    }
}
