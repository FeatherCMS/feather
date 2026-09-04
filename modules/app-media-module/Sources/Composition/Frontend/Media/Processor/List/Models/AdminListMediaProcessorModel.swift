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

struct AdminListMediaProcessorModel: Sendable {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
