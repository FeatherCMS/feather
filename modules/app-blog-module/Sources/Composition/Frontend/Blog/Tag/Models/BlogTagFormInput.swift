import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

public struct BlogTagFormInput: Codable, Sendable, Equatable, Hashable {

    public let title: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let submitAction: String?

    enum CodingKeys: String, CodingKey {
        case title
        case excerpt
        case content
        case imageAssetId
        case submitAction
    }

    init(
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        submitAction: String?
    ) {
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
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
            .emptyToNil
    }

    func withStatus(
        _ status: String
    ) -> Self {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            submitAction: nil
        )
    }
}
