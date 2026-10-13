public import FeatherApplication

public struct AccountDetail: DTO {
    public let userId: String
    public let email: String

    public init(
        userId: String,
        email: String
    ) {
        self.userId = userId
        self.email = email
    }
}
