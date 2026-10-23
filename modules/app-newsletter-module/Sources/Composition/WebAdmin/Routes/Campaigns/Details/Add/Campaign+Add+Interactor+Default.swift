import FeatherWebAdmin
import FeatherWebShared
import NewsletterApplication
import NewsletterModule

extension Campaign.Add.Interactor {
    struct Default: Interface {
        let repository: Campaign.Add.Repository.OpenAPI

        func get() async throws -> Campaign.Add.Model {
            .init(key: "", name: "", fromEmail: "", error: nil)
        }

        func add(payload: Campaign.Add.Form) async throws
            -> Campaign.Add.Model
        {
            do {
                try await repository.createNewsletter(
                    key: payload.normalizedKey,
                    name: payload.normalizedName,
                    fromEmail: payload.normalizedFromEmail
                )
                return try await get()
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw Campaign.Add.WebError.unauthorized
                case .forbidden:
                    throw Campaign.Add.WebError.forbidden
                case .conflict:
                    throw Campaign.Add.WebError.conflict
                case .notFound, .failure, .transport:
                    throw Campaign.Add.WebError.unavailable
                }
            }
        }
    }
}
