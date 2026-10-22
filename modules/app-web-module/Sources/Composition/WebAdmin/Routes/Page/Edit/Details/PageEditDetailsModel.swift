import FeatherWebAdmin
import OpenAPIRuntime

struct PageEditDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAsset: AdminMediaAsset?
    let metadata: AdminMetadataFormValue
}
