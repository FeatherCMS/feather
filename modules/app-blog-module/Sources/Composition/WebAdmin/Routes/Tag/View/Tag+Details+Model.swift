import BlogModule
import FeatherWebAdmin

extension Tag {
    enum Details {}
}

extension Tag.Details {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
    }
}
