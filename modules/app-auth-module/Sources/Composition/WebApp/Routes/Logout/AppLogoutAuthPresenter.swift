import Hummingbird

protocol AppLogoutAuthPresenter: Sendable {
    func expiredSessionCookie() -> Cookie
}
