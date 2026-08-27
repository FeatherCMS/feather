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

    public func isCurrentUserAllowed(
        to permission: PermissionKey
    ) -> Bool {
        currentUserPermissions.contains(permission.rawValue)
    }
}
