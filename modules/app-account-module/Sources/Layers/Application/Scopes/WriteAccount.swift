public import AuthDomain
public import FeatherContracts
public import UserDomain

public struct WriteAccount: Scope {
    public let identity: any IdentityRepository
    public let authEmail: any AuthEmailRepository
    public let credential: any CredentialRepository

    public init(
        identity: any IdentityRepository,
        authEmail: any AuthEmailRepository,
        credential: any CredentialRepository
    ) {
        self.identity = identity
        self.authEmail = authEmail
        self.credential = credential
    }
}
