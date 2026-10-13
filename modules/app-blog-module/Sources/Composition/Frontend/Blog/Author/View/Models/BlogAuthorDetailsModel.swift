import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorDetailsModel: Sendable {
    let id: String
    let name: String
    let excerpt: String
    let content: String
    let profileImageAssetId: String?
    let profileImage: NewAdminMediaAsset?
    let metadata: AdminMetadataFormValue
    let items: [BlogAdminAPI.Components.Schemas.BlogAuthorLinkListItemSchema]
}
