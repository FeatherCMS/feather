import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaFolderModel: Sendable {
    let id: String
    let parentId: String?
    let name: String
    let slug: String
    let slugPath: String
    let assetCount: Int
    let totalSizeBytes: Int64
    let error: String?
}
