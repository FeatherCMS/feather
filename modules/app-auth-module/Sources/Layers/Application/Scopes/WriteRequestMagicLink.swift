import AuthDomain
import FeatherApplication
import FeatherContracts
import SystemApplication

public struct WriteRequestMagicLink: Scope {
    public let credential: any CredentialRepository
    public let identityEmail: any IdentityEmailRepository
    public let magicLink: any MagicLinkRepository
    public let variable: any VariableQueries

    public init(
        credential: any CredentialRepository,
        identityEmail: any IdentityEmailRepository,
        magicLink: any MagicLinkRepository,
        variable: any VariableQueries
    ) {
        self.credential = credential
        self.identityEmail = identityEmail
        self.magicLink = magicLink
        self.variable = variable
    }
}
