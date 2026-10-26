import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule

extension Variant.Processor.List.Interactor {
    struct Default: Interface {
        let repository: any Variant.Processor.List.Repository.Interface

        func list(
            variantId: String,
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorQueryItemSchema
        > {
            do {
                let body =
                    try await repository.search(
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
                case .notFound: throw Variant.Processor.List.Error.notFound
                case .unauthorized:
                    throw Variant.Processor.List.Error.unauthorized
                case .forbidden:
                    throw Variant.Processor.List.Error.forbidden
                case .conflict, .failure, .transport:
                    throw Variant.Processor.List.Error.unavailable
                }
            }
        }
    }
}
