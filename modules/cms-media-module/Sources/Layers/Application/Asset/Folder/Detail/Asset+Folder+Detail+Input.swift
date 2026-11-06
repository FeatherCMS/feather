public import FeatherApplication
public import MediaModule

extension Asset.Folder.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
