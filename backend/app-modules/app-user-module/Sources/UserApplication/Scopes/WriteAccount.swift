import UserDomain
import Application
//import SystemDomain

public struct WriteAccount: Scope {
    public let account: any AccountRepository
    public let role: any RoleRepository
    //    public let permission: any PermissionRepository

    public init(
        account: any AccountRepository,
        role: any RoleRepository,
        //        permission: any PermissionRepository
    ) {
        self.account = account
        self.role = role
    }
}
