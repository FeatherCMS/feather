public import SystemModule
public import FeatherApplication

extension Permission.Detail {
    public struct Input: FeatherApplication.DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
