import Hummingbird

extension Logout {
    enum Presenter {}
}

extension Logout.Presenter {
    protocol Interface: Sendable {
        func expiredSessionCookie() -> Cookie
    }
}
