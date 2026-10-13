public import AuthDomain
public import FeatherContracts

public struct WriteCredentialLink: Scope {
    public let credential: any CredentialRepository
    public let authEmail: any AuthEmailRepository

    public init(
        credential: any CredentialRepository,
        authEmail: any AuthEmailRepository
    ) {
        self.credential = credential
        self.authEmail = authEmail
    }
}
