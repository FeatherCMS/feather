import FeatherAdmin
import MediaAdminAPI

struct AdminListMediaVariantDefaultInteractor: AdminListMediaVariantInteractor {
    let repository: any AdminListMediaVariantRepository

    func listMediaVariants(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
    > {
        do {
            let body = try await repository
                .listMediaVariants(page: page, search: search)
                .body.json
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
            switch error {
            case .unauthorized: throw AdminListMediaVariantError.unauthorized
            case .forbidden: throw AdminListMediaVariantError.forbidden
            case .notFound, .conflict, .failure, .transport:
                throw AdminListMediaVariantError.unavailable
            }
        }
    }
}
