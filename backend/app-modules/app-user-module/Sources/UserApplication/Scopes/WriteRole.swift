import UserDomain
import Application

public struct WriteRole: Scope {
    public let role: any RoleRepository

    public init(role: any RoleRepository) {
        self.role = role
    }
}
