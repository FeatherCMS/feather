public import FeatherApplication
public import SystemModule

extension Job.Detail {
    public struct Input: DTO {
        public let id: String
        public init(id: String) { self.id = id }
    }
}
