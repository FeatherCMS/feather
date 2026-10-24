public import AccountDomain
public import AccountModule
public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import UserDomain
public import UserModule

extension Invitation.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let invitation: any Invitation.Repository.Interface
        public let identity: any Identity.Repository.Interface
        public let role: any Role.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Interface

        public init(
            invitation: any Invitation.Repository.Interface,
            identity: any Identity.Repository.Interface,
            role: any Role.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Interface
        ) {
            self.invitation = invitation
            self.identity = identity
            self.role = role
            self.authEmail = authEmail
            self.variable = variable
        }
    }
}
