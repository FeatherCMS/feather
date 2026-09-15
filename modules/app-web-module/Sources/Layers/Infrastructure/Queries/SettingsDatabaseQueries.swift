//
//  SettingsDatabaseQueries.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure
import WebApplication

public struct SettingsDatabaseQueries: SettingsQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    public func get() async throws -> SettingsDetail {
        let pairs = try await context.connection.run(
            query: #"""
                SELECT key, value
                FROM system_variable
                WHERE key IN (
                    'web-settings-logo',
                    'web-settings-logo-dark',
                    'web-settings-meta-image',
                    'web-settings-primary-color',
                    'web-settings-secondary-color',
                    'web-settings-tertiary-color',
                    'web-settings-primary-font',
                    'web-settings-secondary-font',
                    'web-settings-home-page-id',
                    'web-settings-locale',
                    'web-settings-timezone',
                    'web-settings-title',
                    'web-settings-excerpt',
                    'web-settings-no-index',
                    'web-settings-css',
                    'web-settings-js'
                );
                """#
        ) { sequence in
            let rows = try await sequence.collect()
            return try rows.reduce(into: [String: String]()) { result, row in
                let name = try row.decode(column: "key", as: String.self)
                let value = try row.decode(column: "value", as: String.self)
                result[name] = value
            }
        }

        let logo = pairs["web-settings-logo"] ?? ""
        let logoDark = pairs["web-settings-logo-dark"] ?? ""
        let metaImage = pairs["web-settings-meta-image"] ?? ""
        let primaryColor = pairs["web-settings-primary-color"] ?? ""
        let secondaryColor = pairs["web-settings-secondary-color"] ?? ""
        let tertiaryColor = pairs["web-settings-tertiary-color"] ?? ""
        let primaryFont = pairs["web-settings-primary-font"] ?? ""
        let secondaryFont = pairs["web-settings-secondary-font"] ?? ""
        let homePageId = pairs["web-settings-home-page-id"]
            .flatMap { $0.isEmpty ? nil : $0 }
        let locale = pairs["web-settings-locale"] ?? "en_us"
        let timezone = pairs["web-settings-timezone"] ?? "utc"
        let title = pairs["web-settings-title"] ?? ""
        let excerpt = pairs["web-settings-excerpt"] ?? ""
        let noIndex = (pairs["web-settings-no-index"] ?? "false") == "true"
        let css = pairs["web-settings-css"] ?? ""
        let js = pairs["web-settings-js"] ?? ""

        return .init(
            logo: logo,
            logoDark: logoDark,
            metaImage: metaImage,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            tertiaryColor: tertiaryColor,
            primaryFont: primaryFont,
            secondaryFont: secondaryFont,
            homePageId: homePageId,
            locale: locale,
            timezone: timezone,
            title: title,
            excerpt: excerpt,
            noIndex: noIndex,
            css: css,
            js: js
        )
    }
}
