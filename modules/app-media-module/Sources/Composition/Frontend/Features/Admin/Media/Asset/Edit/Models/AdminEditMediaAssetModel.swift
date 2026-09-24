import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAssetModel: Sendable {
    let id: String
    let url: String
    let `extension`: String
    let status: String
    let sizeBytes: Int64
    let title: String
    let altText: String
    let error: String?
}
