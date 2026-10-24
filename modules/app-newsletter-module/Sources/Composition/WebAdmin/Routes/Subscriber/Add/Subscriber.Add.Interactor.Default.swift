import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add.Interactor {
    struct Default: Interface {
        let repository: any Subscriber.Add.Repository.Interface

        func get() async throws -> Subscriber.Add.Model {
            .init(
                email: "",
                firstName: "",
                lastName: "",
                selectedCampaignIds: [],
                campaigns: try await repository.listCampaigns(),
                error: nil
            )
        }

        func post(form: Subscriber.Add.Form) async throws
            -> Subscriber.Add.Model
        {
            let campaigns = try await repository.listCampaigns()
            guard
                !form.email.whitespaceTrimmed.isEmpty
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
}
