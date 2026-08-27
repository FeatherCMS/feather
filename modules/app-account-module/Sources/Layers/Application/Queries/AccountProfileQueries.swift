import AccountDomain

public protocol AccountProfileQueries: Sendable {

    func get(
        userId: String
    ) async throws -> AccountProfile
}
