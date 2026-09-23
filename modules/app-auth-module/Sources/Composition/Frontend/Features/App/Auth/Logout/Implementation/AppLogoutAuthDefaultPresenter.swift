import FeatherAdmin
import Foundation
import Hummingbird

struct AppLogoutAuthDefaultPresenter: AppLogoutAuthPresenter {
    func expiredSessionCookie() -> Cookie {
        Cookie(
            name: "session_token",
            value: "",
            expires: Date(timeIntervalSince1970: 0),
            maxAge: 0,
            path: "/",
            secure: unsafe AppEnvironmentStore.current.publicOrigins
                .usesSecureCookies,
            httpOnly: true,
            sameSite: .lax
        )
    }
}
