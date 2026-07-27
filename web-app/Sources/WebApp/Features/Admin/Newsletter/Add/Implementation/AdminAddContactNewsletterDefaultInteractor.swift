struct AdminAddContactNewsletterDefaultInteractor:
    AdminAddContactNewsletterInteractor
{
    let repository: AdminAddContactNewsletterOpenAPIRepository

    func getAddContactNewsletter() async throws
        -> AdminAddContactNewsletterModel
    {
        .init(name: "", fromEmail: "", error: nil)
    }

    func postAddContactNewsletter(payload: ContactNewsletterAddForm)
        async throws -> AdminAddContactNewsletterModel
    {
        do {
            try await repository.createNewsletter(
                name: payload.normalizedName,
                fromEmail: payload.normalizedFromEmail
            )
            return .init(name: "", fromEmail: "", error: nil)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                name: payload.name,
                fromEmail: payload.fromEmail,
                error: error.errorDescription
            )
        }
    }
}
