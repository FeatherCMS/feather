public import SystemModule
public import AccountDomain
public import FeatherModuleKit
public import SystemApplication
public import UserDomain

public struct WriteInvitationOnlyWithVariable: Scope {
    public let invitation: any InvitationRepository
    public let role: any Role.Repository.Interface
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        invitation: any InvitationRepository,
        role: any Role.Repository.Interface,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.invitation = invitation
        self.role = role
        self.variable = variable
    }
}
