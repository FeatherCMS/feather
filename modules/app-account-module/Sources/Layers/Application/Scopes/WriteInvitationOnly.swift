import AccountDomain
import FeatherApplication
import FeatherContracts
import UserDomain

public struct WriteInvitationOnly: Scope {
    public let invitation: any InvitationRepository
    public let role: any RoleRepository

    public init(
        invitation: any InvitationRepository,
        role: any RoleRepository
    ) {
        self.invitation = invitation
        self.role = role
    }
}
