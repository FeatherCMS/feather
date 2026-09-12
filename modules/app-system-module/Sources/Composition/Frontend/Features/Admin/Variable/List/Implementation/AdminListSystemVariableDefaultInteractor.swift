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

}
