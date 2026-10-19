public import SystemModule
public import FeatherApplication

extension Variable.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) { self.id = id }
    }
}
