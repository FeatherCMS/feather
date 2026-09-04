import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterSubscriberDefaultInteractor:
    AdminAddNewsletterSubscriberInteractor
{
    let repository: AdminAddNewsletterSubscriberOpenAPIRepository

    func get() async throws -> AdminAddNewsletterSubscriberModel {
        .init(
            email: "",
            firstName: "",
            lastName: "",
            selectedCampaignIds: [],
            campaigns: try await repository.listCampaigns(),
            error: nil
        )
    }

    func post(form: AdminAddNewsletterSubscriberForm) async throws
        -> AdminAddNewsletterSubscriberModel
    {
        let campaigns = try await repository.listCampaigns()
        guard
            !form.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return .init(
                email: form.email,
                firstName: form.firstName,
                lastName: form.lastName,
                selectedCampaignIds: form.selectedCampaignIds,
                campaigns: campaigns,
                error: "Email is required."
            )
        }
        guard !form.selectedCampaignIds.isEmpty else {
            return .init(
                email: form.email,
                firstName: form.firstName,
                lastName: form.lastName,
                selectedCampaignIds: form.selectedCampaignIds,
                campaigns: campaigns,
                error: "Select at least one campaign."
            )
        }
        try await repository.create(form: form, campaigns: campaigns)
        return .init(
            email: form.email,
            firstName: form.firstName,
            lastName: form.lastName,
            selectedCampaignIds: form.selectedCampaignIds,
            campaigns: campaigns,
            error: nil
        )
    }
}
