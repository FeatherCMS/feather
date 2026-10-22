import BlogModule
import FeatherWebAdmin

extension Post.List {
    struct Item: Sendable {
        let id: String
        let title: String
        let metadata: AdminMetadataFormValue
    }
}
