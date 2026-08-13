//
//  MediaAssetCreate.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct MediaAssetCreate: DTO {
    public let folderId: String?
    public let storageKey: String
    public let type: String
    public let sizeBytes: Int64
    public let title: String?
    public let altText: String?

    public init(
        folderId: String? = nil,
        storageKey: String,
        type: String,
        sizeBytes: Int64,
        title: String? = nil,
        altText: String? = nil
    ) {
        self.folderId = folderId
        self.storageKey = storageKey
        self.type = type
        self.sizeBytes = sizeBytes
        self.title = title
        self.altText = altText
    }
}
