import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.Router {
    struct Routes: Sendable {
        let account: WebRoute
        let admin: WebRoute
        let profile: WebRoute
        let settings: WebRoute
        let invitations: WebRoute

        init(
            root: WebRoute,
            admin: WebRoute,
            profile: WebRoute,
            settings: WebRoute,
            invitations: WebRoute
        ) {
            self.account = root.appending(pathComponent: "account")
            self.admin = admin
            self.profile = profile
            self.settings = settings
            self.invitations = invitations
        }

    }

}
