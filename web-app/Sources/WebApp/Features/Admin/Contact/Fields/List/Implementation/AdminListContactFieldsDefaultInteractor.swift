struct AdminListContactFieldsDefaultInteractor:
    AdminListContactFieldsInteractor
{
    let repository: AdminListContactFieldsOpenAPIRepository
    func list() async throws -> [AdminContactFieldRow] {
        try await repository.list()
    }
}
