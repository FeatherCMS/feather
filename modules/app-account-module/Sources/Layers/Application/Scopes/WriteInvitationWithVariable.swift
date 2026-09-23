public import AccountDomain
public import FeatherContracts
public import SystemApplication
public import UserDomain

public struct WriteInvitationWithVariable: Scope {
    public let invitation: any InvitationRepository
    public let identity: any IdentityRepository
    public let role: any RoleRepository
    public let credential: any InvitationCredentialWriter
    public let variable: any VariableQueries

    public init(
        invitation: any InvitationRepository,
        identity: any IdentityRepository,
        role: any RoleRepository,
        credential: any InvitationCredentialWriter,
        variable: any VariableQueries
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
        self.credential = credential
        self.variable = variable
    }
}
