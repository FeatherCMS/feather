import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit {
    struct Model: Sendable {
        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let slugPath: String
        let assetCount: Int
        let totalSizeBytes: Int64
        let error: String?
    }
}
