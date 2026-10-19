public import SystemModule
public import AuthDomain
public import FeatherModuleKit
public import SystemApplication

public struct WriteRequestMagicLink: Scope {
    public let credential: any CredentialRepository
    public let authEmail: any AuthEmailRepository
    public let magicLink: any MagicLinkRepository
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        credential: any CredentialRepository,
        authEmail: any AuthEmailRepository,
        magicLink: any MagicLinkRepository,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.credential = credential
        self.authEmail = authEmail
        self.magicLink = magicLink
        self.variable = variable
    }
}
