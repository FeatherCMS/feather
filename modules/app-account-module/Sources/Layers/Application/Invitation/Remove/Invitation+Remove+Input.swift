public import AccountModule
public import FeatherApplication

extension Invitation.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
