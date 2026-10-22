public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule

extension MagicLink.Request {
    public struct Scope: FeatherModuleKit.Scope {
        public let credential: any Credential.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let magicLink: any MagicLink.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Interface

        public init(
            credential: any Credential.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            magicLink: any MagicLink.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Interface
        ) {
            self.credential = credential
            self.authEmail = authEmail
            self.magicLink = magicLink
            self.variable = variable
        }
    }
}
