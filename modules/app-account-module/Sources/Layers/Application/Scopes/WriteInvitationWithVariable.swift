public import SystemModule
public import AccountDomain
public import AuthDomain
public import FeatherModuleKit
public import SystemApplication
public import UserDomain

public struct WriteInvitationWithVariable: Scope {
    public let invitation: any InvitationRepository
    public let identity: any IdentityRepository
    public let role: any RoleRepository
    public let authEmail: any AuthEmailRepository
    public let credential: any InvitationCredentialWriter
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        invitation: any InvitationRepository,
        identity: any IdentityRepository,
        role: any RoleRepository,
        authEmail: any AuthEmailRepository,
        credential: any InvitationCredentialWriter,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
        self.authEmail = authEmail
        self.credential = credential
        self.variable = variable
    }
}
