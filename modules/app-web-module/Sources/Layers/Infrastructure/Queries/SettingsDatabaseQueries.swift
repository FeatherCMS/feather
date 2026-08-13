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
                SELECT name, value
                FROM system_variable
                WHERE name IN (
                    'web.site.logo',
                    'web.site.logo_dark',
                    'web.site.meta_image',
                    'web.site.primary_color',
                    'web.site.secondary_color',
                    'web.site.tertiary_color',
                    'web.site.primary_font',
                    'web.site.secondary_font',
                    'web.site.home_page_id',
                    'web.site.locale',
                    'web.site.timezone',
                    'web.site.title',
                    'web.site.excerpt',
                    'web.site.no_index',
                    'web.site.css',
                    'web.site.js'
                );
                """#
        ) { sequence in
            let rows = try await sequence.collect()
            return try rows.reduce(into: [String: String]()) { result, row in
                let name = try row.decode(column: "name", as: String.self)
                let value = try row.decode(column: "value", as: String.self)
                result[name] = value
            }
        }

        let logo = pairs["web.site.logo"] ?? ""
        let logoDark = pairs["web.site.logo_dark"] ?? ""
        let metaImage = pairs["web.site.meta_image"] ?? ""
        let primaryColor = pairs["web.site.primary_color"] ?? ""
        let secondaryColor = pairs["web.site.secondary_color"] ?? ""
        let tertiaryColor = pairs["web.site.tertiary_color"] ?? ""
        let primaryFont = pairs["web.site.primary_font"] ?? ""
        let secondaryFont = pairs["web.site.secondary_font"] ?? ""
        let homePageId = pairs["web.site.home_page_id"]
            .flatMap { $0.isEmpty ? nil : $0 }
        let locale = pairs["web.site.locale"] ?? "en_us"
        let timezone = pairs["web.site.timezone"] ?? "utc"
        let title = pairs["web.site.title"] ?? ""
        let excerpt = pairs["web.site.excerpt"] ?? ""
        let noIndex = (pairs["web.site.no_index"] ?? "false") == "true"
        let css = pairs["web.site.css"] ?? ""
        let js = pairs["web.site.js"] ?? ""

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
