import AccountModule
import FeatherModuleKit

extension Settings.Detail {
    struct Action: PermissionAction {
        let key = Settings.Permissions.read
        let userID: String

        func authorize(
            subject: Subject,
            permissions: Set<PermissionKey>
        ) async throws -> Bool {
            userID == subject.id || permissions.contains(key)
        }
    }
}
