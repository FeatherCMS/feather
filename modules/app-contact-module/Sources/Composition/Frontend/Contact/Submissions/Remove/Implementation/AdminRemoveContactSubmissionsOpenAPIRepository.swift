import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactSubmissionsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func bulkRemove(ids: [String]) async throws {
        let grouped = Dictionary(grouping: ids) { token in
            token.split(separator: ":", maxSplits: 1).first.map(String.init)
                ?? ""
        }
        try await api.withOpenAPIRepositoryErrorMapping { client in
            for (formId, tokens) in grouped where !formId.isEmpty {
                let submissionIds = tokens.compactMap { token in
                    let parts = token.split(separator: ":", maxSplits: 1)
                    return parts.count == 2 ? String(parts[1]) : nil
                }
                guard !submissionIds.isEmpty else { continue }
                _ = try await client.contactFormSubmissionBulkDelete(
                    path: .init(contactFormId: formId),
                    body: .json(.init(ids: submissionIds, summary: true))
                )
            }
        }
    }
}
