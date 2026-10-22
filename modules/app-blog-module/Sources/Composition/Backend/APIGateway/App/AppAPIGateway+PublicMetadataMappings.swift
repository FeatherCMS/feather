import BlogAppAPI
import BlogApplication
import Foundation
import WebApplication

extension AppAPIGateway {
    func publicTimestamp(
        _ date: Date?
    ) -> Double? {
        date?.timeIntervalSince1970
    }

    func mapPublicMetadata(
        _ metadata: MetadataDetail,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> BlogAppAPI.Components.Schemas.WebMetadataContentSchema {
        let resolved = ResolvedMetadata(
            metadata: metadata,
            fallbackTitle: title,
            fallbackExcerpt: excerpt,
            fallbackImageURL: imageURL
        )
        return .init(
            slug: metadata.slug,
            template: publicTemplate(for: metadata),
            publicationDate: publicTimestamp(metadata.publicationDate),
            expirationDate: publicTimestamp(metadata.expirationDate),
            status: metadata.status.rawValue,
            title: resolved.title,
            excerpt: resolved.excerpt,
            imageURL: resolved.imageURL ?? "",
            canonicalURL: metadata.canonicalURL,
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }

    private func publicTemplate(
        for metadata: MetadataDetail
    ) -> String {
        guard metadata.template == "default" else {
            return metadata.template
        }
        switch metadata.referenceType {
        case "blog.post": return "blog.post"
        case "blog.author": return "blog.author"
        case "blog.tag": return "blog.tag"
        default: return metadata.template
        }
    }
}
