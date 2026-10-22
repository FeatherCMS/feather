import Hummingbird

extension Logout.Presenter {
    protocol Interface: Sendable {
        func expiredSessionCookie() -> Cookie
    }
}
