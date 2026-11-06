public import FeatherApplication
public import MediaModule

extension Asset.File.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public init(ids: [String]) { self.ids = ids }
    }
}
