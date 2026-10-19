public import SystemModule
//
//  WritePageMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import SystemApplication
public import WebDomain

public struct WritePageMetadata: Scope {
    public let page: any PageRepository
    public let metadata: any MetadataRepository
    public let settings: any SettingsRepository
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        page: any PageRepository,
        metadata: any MetadataRepository,
        settings: any SettingsRepository,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.page = page
        self.metadata = metadata
        self.settings = settings
        self.variable = variable
    }
}
