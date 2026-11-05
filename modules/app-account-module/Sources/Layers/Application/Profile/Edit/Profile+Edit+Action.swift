import AccountModule
import FeatherModuleKit

extension Profile.Edit {
    struct Action: PermissionAction {
        let key = Profile.Permissions.update
        let userID: String

        func authorize(
            subject: Subject,
            permissions: Set<PermissionKey>
        ) async throws -> Bool {
            userID == subject.id || permissions.contains(key)
        }
    }
}
