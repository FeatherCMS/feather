public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import WebDomain

//
//  WritePageMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct WritePageMetadata: Scope {
    public let page: any Page.Repository.Interface
    public let metadata: any Metadata.Repository.Interface
    public let settings: any Settings.Repository.Interface
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        page: any Page.Repository.Interface,
        metadata: any Metadata.Repository.Interface,
        settings: any Settings.Repository.Interface,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.page = page
        self.metadata = metadata
        self.settings = settings
        self.variable = variable
    }
}
