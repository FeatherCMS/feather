import FeatherContracts
import Hummingbird

public protocol AuthRequestContext: RequestContext {
    var sessionToken: String? { get set }
    var account: AccountModel? { get set }
}

extension AuthRequestContext {

    public var currentUserPermissions: Set<String> {
        account?.permissionSet ?? []
    }

    public var currentUserAdminListActions: NewAdminListActions {
        .init(Set(currentUserPermissions.map(PermissionKey.init)))
    }

    public func isCurrentUserAllowed(
        to permission: PermissionKey
    ) -> Bool {
        currentUserPermissions.contains(permission.rawValue)
    }
}
