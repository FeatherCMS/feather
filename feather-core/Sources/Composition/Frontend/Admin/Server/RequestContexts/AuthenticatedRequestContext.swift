public import FeatherContracts
public import Hummingbird

/// Request context used by routes that require an authenticated account.
public struct AuthenticatedRequestContext:
    ChildRequestContext,
    RequestParameterProviding,
    Sendable
{

    public typealias ParentContext = DefaultRequestContext

    public var coreContext: CoreRequestContextStorage
    public let sessionToken: String
    public let account: AccountModel

    public init(context: ParentContext) throws {
        guard
            let sessionToken = context.sessionToken,
            let account = context.account
        else {
            throw HTTPError(.unauthorized)
        }

        self.coreContext = context.coreContext
        self.sessionToken = sessionToken
        self.account = account
    }

    public var requestDecoder: URLFormRequestDecoder {
        .init()
    }

    public var currentUserPermissions: Set<String> {
        account.permissionSet
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
