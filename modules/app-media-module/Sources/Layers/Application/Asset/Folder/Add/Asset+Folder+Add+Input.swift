public import FeatherApplication
public import MediaModule

extension Asset.Folder.Add {
    public struct Input: DTO {
        public let parentId: String?
        public let name: String
        public init(parentId: String?, name: String) {
            self.parentId = parentId
            self.name = name
        }
    }
}
