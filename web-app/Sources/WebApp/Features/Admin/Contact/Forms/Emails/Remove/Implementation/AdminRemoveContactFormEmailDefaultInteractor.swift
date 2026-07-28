struct AdminRemoveContactFormEmailDefaultInteractor:
    AdminRemoveContactFormEmailInteractor
{
    let repository: AdminRemoveContactFormEmailOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }

    func bulkRemove(id: String, emailIds: [String]) async throws {
        let current = try await repository.get(id: id)
        let selected = Set(emailIds)
        let remaining = current.mails.filter { !selected.contains($0.id) }
        guard remaining.count != current.mails.count else {
            throw OpenAPIRepositoryError.notFound(
                message: "The selected contact form emails could not be found."
            )
        }
        _ = try await repository.update(
            id: id,
            name: current.name,
            successMessage: current.successMessage,
            failureMessage: current.failureMessage,
            redirectUrl: current.redirectUrl,
            fieldIDs: current.selectedFieldIDs,
            mails: remaining
        )
    }
}
