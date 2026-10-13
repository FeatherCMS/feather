enum AdminEditNewsletterCampaignError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case conflict
    case unavailable
}
