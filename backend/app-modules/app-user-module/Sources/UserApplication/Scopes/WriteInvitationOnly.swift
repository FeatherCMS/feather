import Application
import UserDomain

public struct WriteInvitationOnly: Scope {
    public let invitation: any InvitationRepository

    public init(
        invitation: any InvitationRepository
    ) {
        self.invitation = invitation
    }
}
