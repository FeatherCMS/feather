public import FeatherApplication
public import MediaModule

extension Asset.Folder.List {
    public struct Input: DTO {
        public let parentId: String?

        public init(parentId: String? = nil) {
            self.parentId = parentId
        }
    }
}
