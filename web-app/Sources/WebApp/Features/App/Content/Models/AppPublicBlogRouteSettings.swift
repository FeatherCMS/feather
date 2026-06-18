import AppOpenAPI
import Foundation

struct AppPublicBlogRouteSettings: Sendable {
    let postListPath: String
    let authorListPath: String
    let tagListPath: String
    let postPathPrefix: String
    let authorPathPrefix: String
    let tagPathPrefix: String
    let siteNoIndex: Bool

    init(
        schema: Components.Schemas.BlogRouteSettingsSchema
    ) {
        self.postListPath = Self.normalize(schema.postListPath)
        self.authorListPath = Self.normalize(schema.authorListPath)
        self.tagListPath = Self.normalize(schema.tagListPath)
        self.postPathPrefix = Self.normalize(schema.postPathPrefix)
        self.authorPathPrefix = Self.normalize(schema.authorPathPrefix)
        self.tagPathPrefix = Self.normalize(schema.tagPathPrefix)
        self.siteNoIndex = schema.siteNoIndex
    }
}

extension AppPublicBlogRouteSettings {
    fileprivate static func normalize(
        _ value: String
    ) -> String {
        value.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
