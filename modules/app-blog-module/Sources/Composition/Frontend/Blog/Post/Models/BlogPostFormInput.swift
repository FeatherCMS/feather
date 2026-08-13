import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

public struct BlogPostFormInput: Codable, Sendable, Equatable, Hashable {

    let title: String
    let excerpt: String
    let content: String
    let imageAssetId: String?
    let authorIds: [String]?
    let tagIds: [String]?
    let submitAction: String?

    enum CodingKeys: String, CodingKey {
        case title
        case excerpt
        case content
        case imageAssetId
        case authorIds
        case tagIds
        case submitAction
    }

    init(
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        authorIds: [String]?,
        tagIds: [String]?,
        submitAction: String?
    ) {
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.authorIds = authorIds
        self.tagIds = tagIds
        self.submitAction = submitAction
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.content = try container.decode(String.self, forKey: .content)
        self.imageAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .imageAssetId
        )
        self.authorIds = try container.decodeIfPresent(
            [String].self,
            forKey: .authorIds
        )
        self.tagIds = try container.decodeIfPresent(
            [String].self,
            forKey: .tagIds
        )
        self.submitAction = try container.decodeIfPresent(
            String.self,
            forKey: .submitAction
        )
    }

    var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedContent: String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExcerpt: String {
        excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedImageAssetId: String? {
        imageAssetId?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
    }

    var normalizedAuthorIds: [String] {
        normalizeIDs(authorIds)
    }

    var normalizedTagIds: [String] {
        normalizeIDs(tagIds)
    }

    func withStatus(
        _ status: String
    ) -> Self {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            submitAction: nil
        )
    }

    private func normalizeIDs(
        _ values: [String]?
    ) -> [String] {
        Array(
            Set(
                (values ?? [])
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            )
        )
        .sorted()
    }
}
