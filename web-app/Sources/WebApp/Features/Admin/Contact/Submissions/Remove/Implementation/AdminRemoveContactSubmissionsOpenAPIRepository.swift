import AdminOpenAPI

struct AdminRemoveContactSubmissionsOpenAPIRepository {
    let api: AdminAPI
    func bulkRemove(ids: [String]) async throws {
        for token in ids {
            let parts = token.split(separator: ":", maxSplits: 1)
                .map(String.init)
            guard parts.count == 2 else { continue }
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormSubmissionDelete(
                    path: .init(
                        contactFormId: parts[0],
                        contactFormSubmissionId: parts[1]
                    )
                )
                switch response {
                case .noContent: return
                case .notFound:
                    throw OpenAPIRepositoryError.notFound(
                        message: "This submission could not be found."
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to delete submissions."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: "Your account cannot delete submissions."
                    )
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
