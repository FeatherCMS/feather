import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactSubmissionsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let formsResponse = try await client.contactFormList()
            guard case .ok(let formsValue) = formsResponse else {
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view contact forms."
                )
            }
            var result: [AdminContactSubmissionDirectoryItem] = []
            for form in try formsValue.body.json {
                let submissionsResponse =
                    try await client.contactFormSubmissionList(
                        path: .init(contactFormId: form.id)
                    )
                guard case .ok(let submissionsValue) = submissionsResponse
                else {
                    throw OpenAPIRepositoryError.forbidden(
                        message:
                            "Your account cannot view contact form submissions."
                    )
                }
                result.append(
                    contentsOf: try submissionsValue.body.json.map {
                        let values = $0.values.additionalProperties
                        return .init(
                            id: $0.id,
                            formId: form.id,
                            formName: form.name,
                            status: $0.status,
                            createdAt: DateFormatting.formatUnixTimestamp(
                                $0.createdAt
                            ),
                            email: values.first {
                                $0.key.lowercased() == "email"
                            }?
                            .value
                        )
                    }
                )
            }
            return result.sorted { $0.createdAt > $1.createdAt }
        }
    }

}
