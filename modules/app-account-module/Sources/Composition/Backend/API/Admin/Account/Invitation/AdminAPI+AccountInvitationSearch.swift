import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountInvitationSearch(
        _ input: Operations.AccountInvitationSearch.Input
    ) async throws -> Operations.AccountInvitationSearch.Output {
        let query: Components.Schemas.AccountInvitationListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeListInvitations()
        let objectQuery = map(query)

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(
                            items: list.items.map(map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
