import BlogModule
import FeatherWebAdmin

extension Tag {
    enum Detail {}
}

extension Tag.Detail {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAsset: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
    }
}
