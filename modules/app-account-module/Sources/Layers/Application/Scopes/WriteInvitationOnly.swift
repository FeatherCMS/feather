public import AccountDomain
public import FeatherContracts
public import UserDomain

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
