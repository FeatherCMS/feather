import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add.Interactor {
    struct Default: Interface {
        let repository: any Issue.Add.Repository.Interface

        func get(newsletterId: String) async throws -> Issue.Form.Model {
            .init(
                subject: "",
                content: "",
                scheduledAt: "",
                newsletterId: newsletterId,
                error: nil
            )
        }

        func add(
            newsletterId: String,
            payload: Issue.Form.Input,
            sendImmediately: Bool
        ) async throws -> Issue.Form.Model {
            do {
                try await repository.createIssue(
                    newsletterId: newsletterId,
                    form: payload,
                    sendImmediately: sendImmediately
                )
                return .init(
                    subject: "",
                    content: "",
                    scheduledAt: "",
                    newsletterId: newsletterId,
                    error: nil
                )
            }
            catch let error as OpenAPIRepositoryError {
                return .init(
                    subject: payload.subject,
                    content: payload.content,
                    scheduledAt: payload.scheduledAt,
                    newsletterId: newsletterId,
                    error: error.errorDescription
                )
            }
        }
    }
}
