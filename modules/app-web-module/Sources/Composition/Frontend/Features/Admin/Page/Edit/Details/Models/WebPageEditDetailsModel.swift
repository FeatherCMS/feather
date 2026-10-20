import FeatherWebAdmin
import OpenAPIRuntime

struct WebPageEditDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAsset: AdminMediaAsset?
    let metadata: AdminMetadataFormValue
}
