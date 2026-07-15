import AdminOpenAPI

struct AdminManageContactFormsOpenAPIRepository {
    let api: AdminAPI

    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminManageContactFormMail]
    ) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormCreate(body: .json(.init(name: name, successMessage: successMessage, failureMessage: failureMessage, redirectUrl: redirectUrl, fieldIds: fieldIDs, mails: mails.map { .init(mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders, messageBody: $0.messageBody) })))
            switch response {
            case .created(let value): let item = try value.body.json; return .init(id: item.id, name: item.name, successMessage: item.successMessage, failureMessage: item.failureMessage, redirectUrl: item.redirectUrl, selectedFieldIDs: [], availableFields: [], mails: (item.mails ?? []).map { .init(id: $0.id, mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders, messageBody: $0.messageBody) })
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to create contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot create contact forms.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func availableFields() async throws -> [AdminManageContactFormFieldOption] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemList(path: .init(contactFormId: "__global_contact_fields__"))
            switch response {
            case .ok(let value):
                return try value.body.json.map { .init(id: $0.id, label: $0.label) }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view contact fields.")
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view contact fields.")
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func list() async throws -> [AdminManageContactFormItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormList()
            switch response {
            case .ok(let value): return try value.body.json.map { .init(id: $0.id, name: $0.name, successMessage: $0.successMessage, failureMessage: $0.failureMessage, redirectUrl: $0.redirectUrl, selectedFieldIDs: [], availableFields: [], mails: []) }
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view contact forms.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func get(id: String) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormGet(path: .init(contactFormId: id))
            switch response {
            case .ok(let value):
                let item = try value.body.json
                let fields = try await availableFields()
                return .init(id: item.id, name: item.name, successMessage: item.successMessage, failureMessage: item.failureMessage, redirectUrl: item.redirectUrl, selectedFieldIDs: (item.items ?? []).map(\.id), availableFields: fields, mails: (item.mails ?? []).map { .init(id: $0.id, mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders, messageBody: $0.messageBody) })
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view this contact form.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view this contact form.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func update(id: String, name: String, successMessage: String, failureMessage: String, redirectUrl: String?, fieldIDs: [String], mails: [AdminManageContactFormMail]) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormUpdate(path: .init(contactFormId: id), body: .json(.init(name: name, successMessage: successMessage, failureMessage: failureMessage, redirectUrl: redirectUrl, fieldIds: fieldIDs, mails: mails.map { .init(mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders, messageBody: $0.messageBody) })))
            switch response {
            case .ok(let value): let item = try value.body.json; return .init(id: item.id, name: item.name, successMessage: item.successMessage, failureMessage: item.failureMessage, redirectUrl: item.redirectUrl, selectedFieldIDs: (item.items ?? []).map(\.id), availableFields: [], mails: (item.mails ?? []).map { .init(id: $0.id, mailFrom: $0.mailFrom, mailTo: $0.mailTo, subject: $0.subject, additionalHeaders: $0.additionalHeaders, messageBody: $0.messageBody) })
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to edit contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot edit contact forms.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormDelete(path: .init(contactFormId: id))
            switch response {
            case .noContent: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to delete contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot delete contact forms.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
