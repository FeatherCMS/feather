import FeatherAdmin
import Hummingbird
import SystemAdminAPI

struct AdminListSystemVariableDefaultInteractor:
    AdminListSystemVariableInteractor
{
    let repository: any AdminListSystemVariableRepository

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.SystemVariableListItemSchema
    > {
        do {
            let response = try await repository.listSystemVariables(
                page: page,
                search: search,
                ids: nil
            )
            let body = try response.body.json
            return .init(
                items: body.data.items,
                pageState: .init(
                    page: body.query.page.number,
                    pageSize: body.query.page.size,
                    total: body.data.total
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminListSystemVariableError {
        switch error {
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .notFound, .conflict, .failure, .transport:
            .unavailable
        }
    }

}
