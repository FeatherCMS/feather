import AdminOpenAPI

struct AdminContactSubmissionsDirectoryOpenAPIRepository {
    let api: AdminAPI

    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let formsResponse = try await client.contactFormList()
            guard case .ok(let formsValue) = formsResponse else {
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view contact forms.")
            }
            var result: [AdminContactSubmissionDirectoryItem] = []
            for form in try formsValue.body.json {
                let submissionsResponse = try await client.contactFormSubmissionList(
                    path: .init(contactFormId: form.id)
                )
                guard case .ok(let submissionsValue) = submissionsResponse else {
                    throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view contact form submissions.")
                }
                result.append(contentsOf: try submissionsValue.body.json.map {
                    let values = $0.values.additionalProperties
                    return .init(
                        id: $0.id,
                        formId: form.id,
                        formName: form.name,
                        status: $0.status,
                        createdAt: DateFormatting.formatUnixTimestamp($0.createdAt),
                        email: values.first { $0.key.lowercased() == "email" }?.value
                    )
                })
            }
            return result.sorted { $0.createdAt > $1.createdAt }
        }
    }

    func bulkRemove(ids: [String]) async throws {
        let items = try await list()
        for token in ids {
            let parts = token.split(separator: ":", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { continue }
            guard items.contains(where: { $0.formId == parts[0] && $0.id == parts[1] }) else { continue }
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormSubmissionDelete(path: .init(contactFormId: parts[0], contactFormSubmissionId: parts[1]))
                switch response {
                case .noContent: return
                case .notFound: throw OpenAPIRepositoryError.notFound(message: "This submission could not be found.")
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to delete submissions.")
                case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot delete submissions.")
                case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
                }
            }
        }
    }
}
