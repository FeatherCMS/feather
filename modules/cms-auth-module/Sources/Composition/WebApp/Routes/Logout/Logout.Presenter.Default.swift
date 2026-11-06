import FeatherWebApp
import Foundation
import Hummingbird

extension Logout.Presenter {
    struct Default: Interface {
        let usesSecureCookies: Bool

        func expiredSessionCookie() -> Cookie {
            Cookie(
                name: "session_token",
                value: "",
                expires: Date(timeIntervalSince1970: 0),
                maxAge: 0,
                path: "/",
                secure: usesSecureCookies,
                httpOnly: true,
                sameSite: .lax
            )
        }
    }
}
