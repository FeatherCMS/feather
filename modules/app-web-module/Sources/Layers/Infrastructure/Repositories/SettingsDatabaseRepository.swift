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
            key: "web-settings-logo",
            name: "Website logo",
            value: model.logo,
            notes: "Logo of the website"
        )
        try await save(
            key: "web-settings-logo-dark",
            name: "Website dark logo",
            value: model.logoDark,
            notes: "Logo of the website in dark mode"
        )
        try await save(
            key: "web-settings-meta-image",
            name: "Website metadata image",
            value: model.metaImage,
            notes: "Default metadata image of the website"
        )
        try await save(
            key: "web-settings-primary-color",
            name: "Website primary color",
            value: model.primaryColor,
            notes: "Primary color of the website"
        )
        try await save(
            key: "web-settings-secondary-color",
            name: "Website secondary color",
            value: model.secondaryColor,
            notes: "Secondary color of the website"
        )
        try await save(
            key: "web-settings-tertiary-color",
            name: "Website tertiary color",
            value: model.tertiaryColor,
            notes: "Tertiary color of the website"
        )
        try await save(
            key: "web-settings-primary-font",
            name: "Website primary font",
            value: model.primaryFont,
            notes: "Primary font of the website"
        )
        try await save(
            key: "web-settings-secondary-font",
            name: "Website secondary font",
            value: model.secondaryFont,
            notes: "Secondary font of the website"
        )
        try await save(
            key: "web-settings-home-page-id",
            name: "Website home page",
            value: model.homePageId ?? "",
            notes: "Selected home page of the website"
        )
        try await save(
            key: "web-settings-locale",
            name: "Website locale",
            value: model.locale,
            notes: "Default locale of the website"
        )
        try await save(
            key: "web-settings-timezone",
            name: "Website timezone",
            value: model.timezone,
            notes: "Default timezone of the website"
        )
        try await save(
            key: "web-settings-title",
            name: "Website title",
            value: model.title,
            notes: "Title of the website"
        )
        try await save(
            key: "web-settings-excerpt",
            name: "Website excerpt",
            value: model.excerpt,
            notes: "Excerpt for the website"
        )
        try await save(
            key: "web-settings-no-index",
            name: "Disable website indexing",
            value: model.noIndex ? "true" : "false",
            notes: "Disable site indexing by search engines"
        )
        try await save(
            key: "web-settings-css",
            name: "Website custom CSS",
            value: model.css,
            notes: "Global CSS injection for the site"
        )
        try await save(
            key: "web-settings-js",
            name: "Website custom JavaScript",
            value: model.js,
            notes: "Global JavaScript injection for the site"
        )
        return try await get()
    }

    private func save(
        key: String,
        name: String,
        value: String,
        notes: String
    ) async throws {
        if var existing = try await variableRepository.find(key: key) {
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
                    key: key,
                    value: value,
                    name: name,
                    notes: notes
                )
            )
        }
    }
}
