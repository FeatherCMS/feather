import FeatherAdmin
import MediaAdminAPI

struct AdminListMediaVariantProcessorsDefaultInteractor:
    AdminListMediaVariantProcessorsInteractor
{
    let repository: any AdminListMediaVariantProcessorsRepository

    func list(
        variantId: String,
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    > {
        do {
            let body =
                try await repository.list(
                    variantId: variantId,
                    page: page,
                    search: search
                )
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
            case .notFound: throw AdminListMediaVariantProcessorsError.notFound
            case .unauthorized:
                throw AdminListMediaVariantProcessorsError.unauthorized
            case .forbidden:
                throw AdminListMediaVariantProcessorsError.forbidden
            case .conflict, .failure, .transport:
                throw AdminListMediaVariantProcessorsError.unavailable
            }
        }
    }
}
