import FeatherModuleKit
import NewsletterModule

extension Issue.Send {
    struct CampaignReadAction: PermissionAction {
        let key = Campaign.Permissions.read
    }
}
