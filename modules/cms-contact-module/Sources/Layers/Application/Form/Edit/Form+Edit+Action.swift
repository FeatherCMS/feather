import ContactModule
import FeatherModuleKit

extension Form.Edit {
    struct Action: PermissionAction {
        let key = Form.Permissions.update
    }

    struct MailCreateAction: PermissionAction {
        let key = SubmissionMail.Permissions.create
    }

    struct MailListAction: PermissionAction {
        let key = SubmissionMail.Permissions.list
    }

    struct MailDeleteAction: PermissionAction {
        let key = SubmissionMail.Permissions.delete
    }
}
