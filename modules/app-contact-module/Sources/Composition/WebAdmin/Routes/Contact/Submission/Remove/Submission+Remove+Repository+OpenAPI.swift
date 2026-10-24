import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared

extension Submission.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(ids: [String]) async throws {
            let grouped = Dictionary(grouping: ids) { token in
                token.split(separator: ":", maxSplits: 1).first.map(String.init)
                    ?? ""
            }
            try await api.withOpenAPIRepositoryErrorMapping { client in
                for (formKey, tokens) in grouped where !formKey.isEmpty {
                    let submissionIDs = tokens.compactMap { token in
                        let parts = token.split(separator: ":", maxSplits: 1)
                        return parts.count == 2 ? String(parts[1]) : nil
                    }
                    guard !submissionIDs.isEmpty else { continue }
                    _ = try await client.contactFormSubmissionRemove(
                        path: .init(contactFormKey: formKey),
                        body: .json(.init(ids: submissionIDs))
                    )
                }
            }
        }

        func remove(formId: String, ids: [String]) async throws {
            guard !ids.isEmpty else { return }
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.contactFormSubmissionRemove(
                    path: .init(contactFormKey: formId),
                    body: .json(.init(ids: ids))
                )
            }
        }
    }
}
