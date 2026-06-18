import UserDomain
import Application

public struct ReadRole: Scope {
    public let role: any RoleQueries

    public init(
        role: any RoleQueries
    ) {
        self.role = role
    }
}
