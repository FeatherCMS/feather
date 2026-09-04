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
import WebComponents
import WebBuilders

struct AdminListBlogAuthorItemModel: Sendable {
    let id: String
    let name: String
    let profileImageAssetId: String?
    let profileImage: AdminMediaAssetReferenceModel?
    let metadata: AdminMetadataFormValue
}
