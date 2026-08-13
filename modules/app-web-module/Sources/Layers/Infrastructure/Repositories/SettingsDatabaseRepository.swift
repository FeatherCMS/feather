//
//  SettingsDatabaseRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure
import WebApplication
import WebDomain

public struct SettingsDatabaseRepository: SettingsRepository {

    public let context: any DatabaseContext
    public var variableRepository: any VariableRepository

    public init(context: any DatabaseContext) {
        self.context = context
        self.variableRepository = VariableDatabaseRepository(context: context)
    }

    public func get(

        ) async throws -> Settings
    {
        let detail = try await SettingsDatabaseQueries(
            context: DatabaseQueryContext(connection: context.connection)
        )
        .get()
        return .init(
            logo: detail.logo,
            logoDark: detail.logoDark,
            metaImage: detail.metaImage,
            primaryColor: detail.primaryColor,
            secondaryColor: detail.secondaryColor,
            tertiaryColor: detail.tertiaryColor,
            primaryFont: detail.primaryFont,
            secondaryFont: detail.secondaryFont,
            homePageId: detail.homePageId,
            locale: detail.locale,
            timezone: detail.timezone,
            title: detail.title,
            excerpt: detail.excerpt,
            noIndex: detail.noIndex,
            css: detail.css,
            js: detail.js
        )
    }

    public func update(
        _ model: Settings
    ) async throws -> Settings {
        try await save(
            id: "web-settings-logo",
            name: "web.site.logo",
            value: model.logo,
            notes: "Logo of the website"
        )
        try await save(
            id: "web-settings-logo-dark",
            name: "web.site.logo_dark",
            value: model.logoDark,
            notes: "Logo of the website in dark mode"
        )
        try await save(
            id: "web-settings-meta-image",
            name: "web.site.meta_image",
            value: model.metaImage,
            notes: "Default metadata image of the website"
        )
        try await save(
            id: "web-settings-primary-color",
            name: "web.site.primary_color",
            value: model.primaryColor,
            notes: "Primary color of the website"
        )
        try await save(
            id: "web-settings-secondary-color",
            name: "web.site.secondary_color",
            value: model.secondaryColor,
            notes: "Secondary color of the website"
        )
        try await save(
            id: "web-settings-tertiary-color",
            name: "web.site.tertiary_color",
            value: model.tertiaryColor,
            notes: "Tertiary color of the website"
        )
        try await save(
            id: "web-settings-primary-font",
            name: "web.site.primary_font",
            value: model.primaryFont,
            notes: "Primary font of the website"
        )
        try await save(
            id: "web-settings-secondary-font",
            name: "web.site.secondary_font",
            value: model.secondaryFont,
            notes: "Secondary font of the website"
        )
        try await save(
            id: "web-settings-home-page-id",
            name: "web.site.home_page_id",
            value: model.homePageId ?? "",
            notes: "Selected home page of the website"
        )
        try await save(
            id: "web-settings-locale",
            name: "web.site.locale",
            value: model.locale,
            notes: "Default locale of the website"
        )
        try await save(
            id: "web-settings-timezone",
            name: "web.site.timezone",
            value: model.timezone,
            notes: "Default timezone of the website"
        )
        try await save(
            id: "web-settings-title",
            name: "web.site.title",
            value: model.title,
            notes: "Title of the website"
        )
        try await save(
            id: "web-settings-excerpt",
            name: "web.site.excerpt",
            value: model.excerpt,
            notes: "Excerpt for the website"
        )
        try await save(
            id: "web-settings-no-index",
            name: "web.site.no_index",
            value: model.noIndex ? "true" : "false",
            notes: "Disable site indexing by search engines"
        )
        try await save(
            id: "web-settings-css",
            name: "web.site.css",
            value: model.css,
            notes: "Global CSS injection for the site"
        )
        try await save(
            id: "web-settings-js",
            name: "web.site.js",
            value: model.js,
            notes: "Global JavaScript injection for the site"
        )
        return try await get()
    }

    private func save(
        id: String,
        name: String,
        value: String,
        notes: String
    ) async throws {
        if var existing = try await variableRepository.find(id: id) {
            try existing.update(
                name: name,
                value: value,
                notes: notes
            )
            _ = try await variableRepository.update(existing)
        }
        else {
            _ = try await variableRepository.insert(
                try Variable.create(
                    id: id,
                    value: value,
                    name: name,
                    notes: notes
                )
            )
        }
    }
}
