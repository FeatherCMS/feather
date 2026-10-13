import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFieldOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(id: String) async throws
        -> AdminContactFieldRow
    {
        try await AdminListContactFieldsOpenAPIRepository(api: api)
            .list().first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound
            }()
    }
    func update(id: String, form: ContactFieldFormInput)
        async throws
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let body: Components.RequestBodies.FormFieldPatchRequestBody =
                .json(
                    .init(
                        key: form.key,
                        _type: form.type,
                        label: form.label,
                        allowedValues: form.normalizedAllowedValues,
                        isRequired: form.isRequiredValue
                    )
                )
            let response = try await client.contactFieldUpdate(
                path: .init(formFieldId: id),
                body: body
            )
            switch response {
            case .ok: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
