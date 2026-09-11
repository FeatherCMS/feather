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

struct AdminAddMediaFolderModel: Sendable {
    let parentId: String?
    let name: String
    let view: String
    let error: String?
}
