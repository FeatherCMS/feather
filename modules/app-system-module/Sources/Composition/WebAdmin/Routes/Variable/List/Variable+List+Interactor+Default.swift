import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension Variable.List.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Variable.List.Repository.Interface

        func listSystemVariables(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
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
                    items: body.data.items.map { item in
                        .init(
                            id: item.id,
                            key: item.key,
                            value: item.value,
                            name: item.name,
                            notes: item.notes
                        )
                    },
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
        ) -> Variable.List.Error {
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
}
