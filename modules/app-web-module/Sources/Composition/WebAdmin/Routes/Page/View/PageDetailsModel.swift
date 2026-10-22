import FeatherWebAdmin
import OpenAPIRuntime

struct PageDetailsModel: Sendable {
    let id: String
    let title: String
    let excerpt: String
    let content: String
    let imageAsset: AdminMediaAsset?
}
