import FeatherModuleKit
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    func campaignKey(for id: String, subject: Subject) async throws -> String {
        try await useCases.makeDetailCampaign()
            .execute(subject: subject, input: .init(id: id))
            .key
    }
}
