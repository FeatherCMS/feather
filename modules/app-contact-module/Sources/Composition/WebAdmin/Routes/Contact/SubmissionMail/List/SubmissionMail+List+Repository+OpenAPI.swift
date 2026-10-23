import ContactAdminAPI
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
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
        func get(id: String) async throws -> AdminContactFormDetailsItem
    }

    struct OpenAPI: Interface {
        let api: ContactAdminAPIClient
        func get(id: String) async throws -> AdminContactFormDetailsItem {
            try await AdminViewContactFormOpenAPIRepository(api: api)
                .get(key: id)
        }
    }
}
