public import FeatherApplication
public import SystemModule

extension Variable.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public init(ids: [String]) { self.ids = ids }
    }
}
