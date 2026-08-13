//
//  SettingsDetail.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct SettingsDetail: DTO {
    public let logo: String
    public let logoDark: String
    public let metaImage: String
    public let primaryColor: String
    public let secondaryColor: String
    public let tertiaryColor: String
    public let primaryFont: String
    public let secondaryFont: String
    public let homePageId: String?
    public let locale: String
    public let timezone: String
    public let title: String
    public let excerpt: String
    public let noIndex: Bool
    public let css: String
    public let js: String

    package init(
        logo: String,
        logoDark: String,
        metaImage: String,
        primaryColor: String,
        secondaryColor: String,
        tertiaryColor: String,
        primaryFont: String,
        secondaryFont: String,
        homePageId: String?,
        locale: String,
        timezone: String,
        title: String,
        excerpt: String,
        noIndex: Bool,
        css: String,
        js: String
    ) {
        self.logo = logo
        self.logoDark = logoDark
        self.metaImage = metaImage
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.homePageId = homePageId
        self.locale = locale
        self.timezone = timezone
        self.title = title
        self.excerpt = excerpt
        self.noIndex = noIndex
        self.css = css
        self.js = js
    }
}
