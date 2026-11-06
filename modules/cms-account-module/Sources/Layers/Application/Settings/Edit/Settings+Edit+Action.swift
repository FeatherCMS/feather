import AccountModule
import FeatherModuleKit

extension Settings.Edit {
    struct Action: PermissionAction {
        let key = Settings.Permissions.update
        let userID: String

        func authorize(
            subject: Subject,
            permissions: Set<PermissionKey>
        ) async throws -> Bool {
            userID == subject.id || permissions.contains(key)
        }
    }
}
