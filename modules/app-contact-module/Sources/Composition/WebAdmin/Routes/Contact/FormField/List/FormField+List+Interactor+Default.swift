import ContactApplication
import ContactModule

extension FormField.List.Interactor {
    struct Default: Interface {
        let repository: any FormField.List.Repository.Interface

        func search(
            page: Int,
            search: String?,
            formKey: String?
        ) async throws -> FormField.List.Model {
            try await repository.search(
                page: page,
                search: search,
                formKey: formKey
            )
        }
    }
}
