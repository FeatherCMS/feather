import FeatherAdmin
import FeatherContracts
import OpenAPIRuntime

public struct WebPageFormInput: Codable, Sendable, Equatable, Hashable {

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
        title.whitespaceTrimmed
    }

    var normalizedContent: String {
        content.whitespaceTrimmed
    }

    var normalizedExcerpt: String {
        excerpt.whitespaceTrimmed
    }

    var normalizedImageAssetId: String? {
        imageAssetId?
            .whitespaceTrimmed
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
