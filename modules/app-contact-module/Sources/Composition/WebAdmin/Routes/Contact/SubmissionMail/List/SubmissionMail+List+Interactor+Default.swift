import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List.Interactor {
    struct Default: Interface {
        let repository: any SubmissionMail.List.Repository.Interface
        func get(id: String) async throws -> AdminContactFormDetailsItem {
            try await repository.get(id: id)
        }
    }
}
