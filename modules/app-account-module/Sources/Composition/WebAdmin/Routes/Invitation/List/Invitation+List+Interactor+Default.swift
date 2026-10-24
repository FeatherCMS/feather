import AccountAdminAPI
import AccountModule

extension Invitation.List.Interactor {

    struct Default:
        Invitation.List.Interactor.Interface
    {
        let repository: any Invitation.List.Repository.Interface

        func execute(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> Invitation.List.Result {
            try await repository.list(
                page: page,
                size: size,
                search: search
            )
        }

    }
}
