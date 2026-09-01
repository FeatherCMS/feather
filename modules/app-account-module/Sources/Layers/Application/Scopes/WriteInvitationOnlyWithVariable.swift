import AccountDomain
import FeatherApplication
import FeatherContracts
import SystemApplication
import UserDomain

public struct WriteInvitationOnlyWithVariable: Scope {
    public let invitation: any InvitationRepository
    public let role: any RoleRepository
    public let variable: any VariableQueries

    public init(
        invitation: any InvitationRepository,
        role: any RoleRepository,
        variable: any VariableQueries
    ) {
        self.invitation = invitation
        self.role = role
        self.variable = variable
    }
}
