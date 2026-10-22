import WebAdminAPI

public protocol AdminMetadataDetailSchema {
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

extension Components.Schemas.WebMetadataDetailSchema:
    AdminMetadataDetailSchema
{}
