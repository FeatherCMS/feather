public import FeatherApplication
public import MediaModule

extension Asset.File.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
