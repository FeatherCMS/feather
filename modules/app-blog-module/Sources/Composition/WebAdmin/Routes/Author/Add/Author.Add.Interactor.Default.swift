import BlogModule

extension Author.Add.Interactor {
    struct Default: Interface {
        let repository: any Author.Add.Repository.Interface

        func execute(input: Author.Form.Input) async throws {
            try await repository.create(input: input)
        }
    }
}
