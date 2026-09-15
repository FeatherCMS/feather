import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaProcessorModel: Sendable {
    let id: String
    let fileSuffix: String
    let matchExtensions: String
    let commandTemplate: String
    let error: String?
}
