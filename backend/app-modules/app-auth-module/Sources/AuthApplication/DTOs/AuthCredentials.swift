public struct AuthCredentials: Sendable {
    public var email: String
    public var password: String
    public var isPersistent: Bool

    public init(
        email: String,
        password: String,
        isPersistent: Bool
    ) {
        self.email = email
        self.password = password
        self.isPersistent = isPersistent
    }
}
