import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Details {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
    }
}
