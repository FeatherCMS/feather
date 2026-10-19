public import SystemModule
public import FeatherApplication

extension Permission.Remove {
    public struct Input: FeatherApplication.DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
