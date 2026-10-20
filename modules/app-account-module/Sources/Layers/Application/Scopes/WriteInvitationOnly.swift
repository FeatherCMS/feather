public import AuthDomain
public import AccountDomain
public import FeatherModuleKit
public import UserDomain

public struct WriteInvitationOnly: Scope {
    public let invitation: any InvitationRepository
    public let identity: any Identity.Repository.Interface
    public let role: any Role.Repository.Interface
    public let authEmail: any AuthEmailRepository

    public init(
        invitation: any InvitationRepository,
        identity: any Identity.Repository.Interface,
        role: any Role.Repository.Interface,
        authEmail: any AuthEmailRepository
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
        self.authEmail = authEmail
    }
}
