//
//  WriteMedia.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import MediaDomain

public struct WriteMedia: Scope {
    public let folders: any MediaAssetNodeFolderRepository
    public let assets: any MediaAssetNodeFileRepository
    public let storageObjects: any MediaAssetStorageObjectRepository
    public let processors: any MediaProcessorRepository
    public let variants: any MediaAssetNodeFileVariantRepository

    public init(
        folders: any MediaAssetNodeFolderRepository,
        assets: any MediaAssetNodeFileRepository,
        storageObjects: any MediaAssetStorageObjectRepository,
        processors: any MediaProcessorRepository,
        variants: any MediaAssetNodeFileVariantRepository
    ) {
        self.folders = folders
        self.assets = assets
        self.storageObjects = storageObjects
        self.processors = processors
        self.variants = variants
    }
}
