public import AuthDomain
public import AccountDomain
public import FeatherContracts
public import UserDomain

public struct WriteInvitationOnly: Scope {
    public let invitation: any InvitationRepository
    public let identity: any IdentityRepository
    public let role: any RoleRepository
    public let authEmail: any AuthEmailRepository

    public init(
        invitation: any InvitationRepository,
        identity: any IdentityRepository,
        role: any RoleRepository,
        authEmail: any AuthEmailRepository
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
        self.authEmail = authEmail
    }
}
