import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule

extension Variant.List.Interactor {
    struct Default: Variant.List.Interactor.Interface {
        let repository: any Variant.List.Repository.Interface

        func listMediaVariants(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
        > {
            do {
                let body =
                    try await repository
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
                case .unauthorized: throw Variant.List.Error.unauthorized
                case .forbidden: throw Variant.List.Error.forbidden
                case .notFound, .conflict, .failure, .transport:
                    throw Variant.List.Error.unavailable
                }
            }
        }
    }
}
