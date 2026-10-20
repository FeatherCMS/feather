public import FeatherApplication
public import SystemModule

extension Permission.Detail {
    public struct Input: FeatherApplication.DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
