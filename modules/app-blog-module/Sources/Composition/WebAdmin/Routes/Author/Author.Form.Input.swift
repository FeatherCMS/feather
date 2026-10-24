import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.Form {
    struct Input: Codable, Sendable, Equatable, Hashable {

        let name: String
        let excerpt: String
        let content: String
        let profileImageAssetId: String?
        let submitAction: String?

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

        init(from decoder: any Decoder) throws {
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
}
