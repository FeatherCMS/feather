//
//  WriteMedia.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import MediaDomain

public struct WriteMedia: Scope {
    public let folders: any MediaFolderRepository
    public let assets: any MediaAssetRepository
    public let processors: any MediaProcessorRepository
    public let processorAssets: any MediaProcessorAssetRepository

    public init(
        folders: any MediaFolderRepository,
        assets: any MediaAssetRepository,
        processors: any MediaProcessorRepository,
        processorAssets: any MediaProcessorAssetRepository
    ) {
        self.folders = folders
        self.assets = assets
        self.processors = processors
        self.processorAssets = processorAssets
    }
}
