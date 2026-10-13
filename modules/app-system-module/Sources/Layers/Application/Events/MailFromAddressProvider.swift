public import FeatherContracts

public struct MailFromAddressProvider: Event {
    public struct Output: Sendable, Hashable {
        public let email: String
        public let name: String?

        public init(
            email: String,
            name: String? = nil
        ) {
            self.email = email
            self.name = name
        }
    }

    public init() {}
}
