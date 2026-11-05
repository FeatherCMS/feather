public import AccountModule
public import FeatherApplication

extension Invitation.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
