//
//  PublicContentMediaVariant.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct PublicContentMediaVariant: DTO {
    public let key: String
    public let url: String

    public init(
        key: String,
        url: String
    ) {
        self.key = key
        self.url = url
    }
}
