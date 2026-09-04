import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AppLogoutAuthDefaultPresenter: AppLogoutAuthPresenter {
    func expiredSessionCookie() -> Cookie {
        Cookie(
            name: "session_token",
            value: "",
            expires: Date(timeIntervalSince1970: 0),
            maxAge: 0,
            path: "/",
            secure: AppEnvironmentStore.current.publicOrigins.usesSecureCookies,
            httpOnly: true,
            sameSite: .lax
        )
    }
}
