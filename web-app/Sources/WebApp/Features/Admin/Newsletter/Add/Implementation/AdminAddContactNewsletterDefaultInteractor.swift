struct AdminAddContactNewsletterDefaultInteractor: AdminAddContactNewsletterInteractor {
    let repository: AdminAddContactNewsletterOpenAPIRepository

    func getAddContactNewsletter() async throws -> AdminAddContactNewsletterModel {
        .init(name: "", error: nil)
    }

    func postAddContactNewsletter(payload: ContactNewsletterAddForm) async throws -> AdminAddContactNewsletterModel {
        do {
            try await repository.createNewsletter(name: payload.normalizedName)
            return .init(name: "", error: nil)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(name: payload.name, error: error.errorDescription)
        }
    }
}
