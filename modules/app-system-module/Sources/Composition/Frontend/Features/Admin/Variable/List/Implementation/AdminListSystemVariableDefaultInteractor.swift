import SystemAdminAPI
import FeatherAdmin
import Hummingbird

struct AdminListSystemVariableDefaultInteractor:
    AdminListSystemVariableInteractor
{
    let repository: any AdminListSystemVariableRepository

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<Components.Schemas.SystemVariableListItemSchema> {
        let response = try await repository.listSystemVariables(
            page: page,
            search: search
        )
        let body = try response.body.json
        return .init(
            items: body.data.items,
            page: body.query.page.number,
            pageSize: body.query.page.size,
            total: body.data.total
        )
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
