import UserDomain
import Application

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository

    public init(invitation: any InvitationRepository) {
        self.invitation = invitation
    }
}
