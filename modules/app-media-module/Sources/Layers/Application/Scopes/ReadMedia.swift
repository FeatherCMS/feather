//
//  ReadMedia.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct ReadMedia: Scope {
    public let folders: any MediaFolderQueries
    public let assets: any MediaAssetQueries
    public let assetSearch: any MediaAssetSearchQueries

    public init(
        folders: any MediaFolderQueries,
        assets: any MediaAssetQueries,
        assetSearch: any MediaAssetSearchQueries
    ) {
        self.folders = folders
        self.assets = assets
        self.assetSearch = assetSearch
    }
}
