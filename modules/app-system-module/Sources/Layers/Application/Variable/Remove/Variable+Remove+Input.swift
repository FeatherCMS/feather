public import SystemModule
public import FeatherApplication

extension Variable.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public init(ids: [String]) { self.ids = ids }
    }
}
