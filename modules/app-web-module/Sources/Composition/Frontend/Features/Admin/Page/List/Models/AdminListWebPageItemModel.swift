import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminListWebPageItemModel: Sendable {
    let id: String
    let title: String
    let metadata: AdminMetadataFormValue
}
