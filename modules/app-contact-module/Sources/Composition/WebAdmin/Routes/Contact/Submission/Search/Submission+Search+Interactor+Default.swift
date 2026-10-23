import ContactModule

extension Submission.Search.Interactor {
    struct Default: Interface {
        let repository: any Submission.Search.Repository.Interface

        func search(page: Int, search: String?) async throws
            -> Submission.Search.Model
        {
            try await repository.search(page: page, search: search)
        }
    }
}
