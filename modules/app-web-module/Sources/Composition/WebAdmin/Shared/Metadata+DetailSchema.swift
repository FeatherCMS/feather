import WebAdminAPI
import WebModule

extension WebModule.Metadata {
    public protocol DetailSchema {
        var slug: String { get }
        var template: String { get }
        var publicationDate: Double? { get }
        var expirationDate: Double? { get }
        var status: String { get }
        var title: String? { get }
        var excerpt: String? { get }
        var imageUrl: String? { get }
        var canonicalUrl: String? { get }
        var noIndex: Bool { get }
        var primaryKeyword: String { get }
        var cssCodeInjection: String? { get }
        var javascriptCodeInjection: String? { get }
        var structuredDataCodeInjection: String? { get }
    }
}

extension Components.Schemas.MetadataDetailSchema:
    WebModule.Metadata.DetailSchema
{}
