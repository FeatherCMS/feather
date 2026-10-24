public import AccountDomain
public import AccountModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule

extension Invitation.Resend {
    public struct Scope: FeatherModuleKit.Scope {
        public let invitation: any Invitation.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Interface

        public init(
            invitation: any Invitation.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Interface
        ) {
            self.invitation = invitation
            self.variable = variable
        }
    }
}
