struct AdminRemoveContactFormEmailDefaultInteractor:
    AdminRemoveContactFormEmailInteractor
{
    let repository: AdminRemoveContactFormEmailOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }

    func remove(id: String, emailId: String) async throws {
        let current = try await repository.get(id: id)
        guard current.mails.contains(where: { $0.id == emailId }) else {
            throw OpenAPIRepositoryError.notFound(
                message: "This contact form email could not be found."
            )
        }
        _ = try await repository.update(
            id: id,
            name: current.name,
            successMessage: current.successMessage,
            failureMessage: current.failureMessage,
            redirectUrl: current.redirectUrl,
            fieldIDs: current.selectedFieldIDs,
            mails: current.mails.filter { $0.id != emailId }
        )
    }
}
