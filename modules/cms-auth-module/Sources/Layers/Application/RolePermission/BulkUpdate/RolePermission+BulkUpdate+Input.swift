public import AuthModule
public import FeatherApplication

extension RolePermission.BulkUpdate {
    public struct Input: DTO, Sendable {
        public let additions: [Pair]
        public let removals: [Pair]

        public init(
            additions: [Pair],
            removals: [Pair]
        ) {
            self.additions = additions
            self.removals = removals
        }
    }
}
