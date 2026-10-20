public import AuthDomain
public import FeatherModuleKit
public import UserDomain

public struct WriteAccount: Scope {
    public let identity: any Identity.Repository.Interface
    public let authEmail: any AuthEmailRepository
    public let credential: any CredentialRepository

    public init(
        identity: any Identity.Repository.Interface,
        authEmail: any AuthEmailRepository,
        credential: any CredentialRepository
    ) {
        self.identity = identity
        self.authEmail = authEmail
        self.credential = credential
    }
}
