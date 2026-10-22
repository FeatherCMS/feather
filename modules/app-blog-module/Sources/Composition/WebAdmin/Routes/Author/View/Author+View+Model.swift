import BlogAdminAPI
import BlogAppAPI
import BlogModule
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

extension Author.View {
    struct Model: Sendable {
        let id: String
        let name: String
        let excerpt: String
        let content: String
        let profileImageAssetId: String?
        let profileImage: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
        let items:
            [BlogAdminAPI.Components.Schemas.AuthorLinkQueryItemSchema]
    }
}
