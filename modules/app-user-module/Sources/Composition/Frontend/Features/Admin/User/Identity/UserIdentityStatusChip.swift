import FeatherAdmin

enum UserIdentityStatusChip {
    static func make(status: String) -> NewAdminChip {
        switch status {
        case "invited":
            NewAdminChip(label: "Invited", color: .blue)
        case "active":
            NewAdminChip(label: "Active", color: .green)
        case "suspended":
            NewAdminChip(label: "Suspended", color: .orange)
        case "deactivated":
            NewAdminChip(label: "Deactivated", color: .red)
        case "anonymized":
            NewAdminChip(label: "Anonymized", color: .purple)
        default:
            NewAdminChip(label: status, color: .blue)
        }
    }
}
