import UserDomain

public protocol InvitationQueries: Sendable {

    func getBy(
        id: String
    ) async throws -> InvitationDetail

    func list(
        query: InvitationList.Query
    ) async throws -> InvitationList

    func count(
        query: InvitationList.Query
    ) async throws -> Int
}
