import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Edit {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
    }
}
