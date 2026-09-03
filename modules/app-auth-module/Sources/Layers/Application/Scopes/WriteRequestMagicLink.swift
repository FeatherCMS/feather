import AuthDomain
import FeatherApplication
import FeatherContracts
import SystemApplication

public struct WriteRequestMagicLink: Scope {
    public let credential: any CredentialRepository
    public let authEmail: any AuthEmailRepository
    public let magicLink: any MagicLinkRepository
    public let variable: any VariableQueries

    public init(
        credential: any CredentialRepository,
        authEmail: any AuthEmailRepository,
        magicLink: any MagicLinkRepository,
        variable: any VariableQueries
    ) {
        self.credential = credential
        self.authEmail = authEmail
        self.magicLink = magicLink
        self.variable = variable
    }
}
