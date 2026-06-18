import WebApplication
import FeatherDatabase
import Infrastructure

public struct DatabaseSettingsQueries: SettingsQueries {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func get() async throws -> SettingsDetail {
        let pairs = try await connection.run(
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

        return .init(
            id: "web-settings",
            logo: pairs["web.site.logo"] ?? "",
            logoDark: pairs["web.site.logo_dark"] ?? "",
            metaImage: pairs["web.site.meta_image"] ?? "",
            primaryColor: pairs["web.site.primary_color"] ?? "",
            secondaryColor: pairs["web.site.secondary_color"] ?? "",
            tertiaryColor: pairs["web.site.tertiary_color"] ?? "",
            primaryFont: pairs["web.site.primary_font"] ?? "",
            secondaryFont: pairs["web.site.secondary_font"] ?? "",
            homePageId: pairs["web.site.home_page_id"]
                .flatMap { $0.isEmpty ? nil : $0 },
            locale: pairs["web.site.locale"] ?? "en_us",
            timezone: pairs["web.site.timezone"] ?? "utc",
            title: pairs["web.site.title"] ?? "",
            excerpt: pairs["web.site.excerpt"] ?? "",
            noIndex: (pairs["web.site.no_index"] ?? "false") == "true",
            css: pairs["web.site.css"] ?? "",
            js: pairs["web.site.js"] ?? ""
        )
    }
}
