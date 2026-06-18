import Foundation
import Hummingbird

protocol AppLogoutUserPresenter: Sendable {
    func expiredSessionCookie() -> Cookie
}
