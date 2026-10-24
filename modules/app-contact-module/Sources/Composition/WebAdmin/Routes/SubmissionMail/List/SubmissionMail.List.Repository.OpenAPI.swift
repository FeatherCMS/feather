import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List {
    enum Repository {}
}

extension SubmissionMail.List.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> ContactModule.Form.Details.Item
    }

    struct OpenAPI: Interface {
        let api: API.Client
        func get(id: String) async throws -> ContactModule.Form.Details.Item {
            try await ContactModule.Form.View.Repository.OpenAPI(api: api)
                .get(key: id)
        }
    }
}
