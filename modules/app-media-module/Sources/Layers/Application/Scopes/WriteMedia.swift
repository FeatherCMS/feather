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
    public let variants: any MediaAssetNodeFileVariantRepository
    public let variantDefinitions: any MediaVariantRepository
    public let variantProcessors: any MediaVariantProcessorRepository

    public init(
        folders: any MediaAssetNodeFolderRepository,
        assets: any MediaAssetNodeFileRepository,
        storageObjects: any MediaAssetStorageObjectRepository,
        variants: any MediaAssetNodeFileVariantRepository,
        variantDefinitions: any MediaVariantRepository,
        variantProcessors: any MediaVariantProcessorRepository
    ) {
        self.folders = folders
        self.assets = assets
        self.storageObjects = storageObjects
        self.variants = variants
        self.variantDefinitions = variantDefinitions
        self.variantProcessors = variantProcessors
    }
}
