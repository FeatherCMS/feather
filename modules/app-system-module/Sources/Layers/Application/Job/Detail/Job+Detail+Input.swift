public import SystemModule
public import FeatherApplication

extension Job.Detail {
    public struct Input: DTO {
        public let id: String
        public init(id: String) { self.id = id }
    }
}
