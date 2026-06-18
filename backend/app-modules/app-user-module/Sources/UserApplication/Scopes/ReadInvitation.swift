import UserDomain
import Application

public struct ReadInvitation: Scope {
    public let invitation: any InvitationQueries

    public init(
        invitation: any InvitationQueries
    ) {
        self.invitation = invitation
    }
}
