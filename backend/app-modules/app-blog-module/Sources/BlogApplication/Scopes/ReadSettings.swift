//
//  ReadSettings.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain

public struct ReadSettings: Scope {
    public let settings: any SettingsQueries

    public init(settings: any SettingsQueries) {
        self.settings = settings
    }
}
