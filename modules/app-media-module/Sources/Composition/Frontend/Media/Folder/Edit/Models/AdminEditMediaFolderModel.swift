import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditMediaFolderModel: Sendable {
    let id: String
    let parentId: String?
    let name: String
    let path: String
    let assetCount: Int
    let totalSizeBytes: Int64
    let error: String?
}
