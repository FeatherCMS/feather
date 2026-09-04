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

struct AdminEditMediaAssetModel: Sendable {
    let id: String
    let storageKey: String
    let type: String
    let status: String
    let sizeBytes: Int64
    let title: String
    let altText: String
    let error: String?
}
