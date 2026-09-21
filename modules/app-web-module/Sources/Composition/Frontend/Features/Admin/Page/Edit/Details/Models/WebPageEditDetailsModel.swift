import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct WebPageEditDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAsset: NewAdminMediaAsset?
    let metadata: AdminMetadataFormValue
}
