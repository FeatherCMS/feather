import BlogModule
import FeatherWebAdmin

extension Tag.List {
    struct Item: Sendable {
        let id: String
        let title: String
        let metadata: AdminMetadataFormValue
    }
}
