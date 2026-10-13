import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

public struct BlogAuthorFormInput: Codable, Sendable, Equatable, Hashable {

    public let name: String
    public let excerpt: String
    public let content: String
    public let profileImageAssetId: String?
    public let submitAction: String?

    enum CodingKeys: String, CodingKey {
        case name
        case excerpt
        case content
        case profileImageAssetId
        case submitAction
    }

    init(
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String?,
        submitAction: String?
    ) {
        self.name = name
        self.excerpt = excerpt
        self.content = content
        self.profileImageAssetId = profileImageAssetId
        self.submitAction = submitAction
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.content = try container.decode(String.self, forKey: .content)
        self.profileImageAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .profileImageAssetId
        )
        self.submitAction = try container.decodeIfPresent(
            String.self,
            forKey: .submitAction
        )
    }

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedContent: String {
        content.whitespaceTrimmed
    }

    var normalizedExcerpt: String {
        excerpt.whitespaceTrimmed
    }

    var normalizedProfileImageAssetId: String? {
        profileImageAssetId?
            .whitespaceTrimmed
            .emptyToNil
    }

    func withStatus(
        _ status: String
    ) -> Self {
        .init(
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            submitAction: nil
        )
    }
}
