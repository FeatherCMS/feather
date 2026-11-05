extension Login.Form {
    struct State {
        var email: String
        var password: String
        var emailError: String?
        var passwordError: String?
        var isPersistent: Bool
        var redirectPath: String
        var turnstileSiteKey: String?

        mutating func apply(errors: [String: String]) {
            emailError = errors["email"]
            passwordError = errors["password"]
        }
    }
}
