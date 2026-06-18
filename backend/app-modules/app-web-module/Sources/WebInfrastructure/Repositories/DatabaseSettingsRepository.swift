import FeatherDatabase
import WebApplication
import WebDomain
import Infrastructure

public struct DatabaseSettingsRepository: SettingsRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func get() async throws -> Settings {
        let detail = try await DatabaseSettingsQueries(connection: connection)
            .get()
        return .init(
            id: detail.id,
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
        try await upsert(
            id: "web-settings-logo",
            name: "web.site.logo",
            value: model.logo,
            notes: "Logo of the website"
        )
        try await upsert(
            id: "web-settings-logo-dark",
            name: "web.site.logo_dark",
            value: model.logoDark,
            notes: "Logo of the website in dark mode"
        )
        try await upsert(
            id: "web-settings-meta-image",
            name: "web.site.meta_image",
            value: model.metaImage,
            notes: "Default metadata image of the website"
        )
        try await upsert(
            id: "web-settings-primary-color",
            name: "web.site.primary_color",
            value: model.primaryColor,
            notes: "Primary color of the website"
        )
        try await upsert(
            id: "web-settings-secondary-color",
            name: "web.site.secondary_color",
            value: model.secondaryColor,
            notes: "Secondary color of the website"
        )
        try await upsert(
            id: "web-settings-tertiary-color",
            name: "web.site.tertiary_color",
            value: model.tertiaryColor,
            notes: "Tertiary color of the website"
        )
        try await upsert(
            id: "web-settings-primary-font",
            name: "web.site.primary_font",
            value: model.primaryFont,
            notes: "Primary font of the website"
        )
        try await upsert(
            id: "web-settings-secondary-font",
            name: "web.site.secondary_font",
            value: model.secondaryFont,
            notes: "Secondary font of the website"
        )
        try await upsert(
            id: "web-settings-home-page-id",
            name: "web.site.home_page_id",
            value: model.homePageId ?? "",
            notes: "Selected home page of the website"
        )
        try await upsert(
            id: "web-settings-locale",
            name: "web.site.locale",
            value: model.locale,
            notes: "Default locale of the website"
        )
        try await upsert(
            id: "web-settings-timezone",
            name: "web.site.timezone",
            value: model.timezone,
            notes: "Default timezone of the website"
        )
        try await upsert(
            id: "web-settings-title",
            name: "web.site.title",
            value: model.title,
            notes: "Title of the website"
        )
        try await upsert(
            id: "web-settings-excerpt",
            name: "web.site.excerpt",
            value: model.excerpt,
            notes: "Excerpt for the website"
        )
        try await upsert(
            id: "web-settings-no-index",
            name: "web.site.no_index",
            value: model.noIndex ? "true" : "false",
            notes: "Disable site indexing by search engines"
        )
        try await upsert(
            id: "web-settings-css",
            name: "web.site.css",
            value: model.css,
            notes: "Global CSS injection for the site"
        )
        try await upsert(
            id: "web-settings-js",
            name: "web.site.js",
            value: model.js,
            notes: "Global JavaScript injection for the site"
        )
        return try await get()
    }

    private func upsert(
        id: String,
        name: String,
        value: String,
        notes: String
    ) async throws {
        _ = try await connection.run(
            query: #"""
                INSERT INTO system_variable (
                    id,
                    name,
                    value,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(id),
                    \#(name),
                    \#(value),
                    \#(notes),
                    NOW(),
                    NOW()
                )
                ON CONFLICT (name) DO UPDATE SET
                    value=EXCLUDED.value,
                    notes=EXCLUDED.notes,
                    updated_at=NOW()
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
