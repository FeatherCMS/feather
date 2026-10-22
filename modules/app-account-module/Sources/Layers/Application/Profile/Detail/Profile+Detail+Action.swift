import AccountModule
import FeatherModuleKit

extension Profile.Detail {
    struct Action: PermissionAction {
        let key = Profile.Permissions.read
        let userID: String

        func authorize(
            subject: Subject,
            permissions: Set<PermissionKey>
        ) async throws -> Bool {
            userID == subject.id || permissions.contains(key)
        }
    }
}
