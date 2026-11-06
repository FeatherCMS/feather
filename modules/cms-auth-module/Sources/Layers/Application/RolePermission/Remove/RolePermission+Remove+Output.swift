public import AuthModule
public import FeatherApplication

extension RolePermission.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
