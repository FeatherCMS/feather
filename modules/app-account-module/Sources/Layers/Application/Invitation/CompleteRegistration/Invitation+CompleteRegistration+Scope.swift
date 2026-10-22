public import AccountDomain
public import AccountModule
public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Invitation.CompleteRegistration {
    public struct Scope: FeatherModuleKit.Scope {
        public let invitation: any Invitation.Repository.Interface
        public let identity: any Identity.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let credential: any InvitationCredentialWriter

        public init(
            invitation: any Invitation.Repository.Interface,
            identity: any Identity.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            credential: any InvitationCredentialWriter
        ) {
            self.invitation = invitation
            self.identity = identity
            self.authEmail = authEmail
            self.credential = credential
        }
    }
}
