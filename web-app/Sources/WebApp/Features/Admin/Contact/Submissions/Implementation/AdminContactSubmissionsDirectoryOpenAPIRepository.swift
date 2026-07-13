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
                    .init(id: $0.id, formId: form.id, formName: form.name, status: $0.status, submittedAt: String($0.submittedAt))
                })
            }
            return result.sorted { $0.submittedAt > $1.submittedAt }
        }
    }
}
