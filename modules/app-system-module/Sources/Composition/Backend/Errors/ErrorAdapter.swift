import SystemApplication
import SystemDomain
import SystemModule

public enum ErrorAdapter {

    public static func adapt(_ error: any Error) -> (any Error)? {
        if let error = error as? SystemModule.Permission.Edit.UseCase.Error {
            return PermissionEditErrorAdapter(error: error)
        }
        if let error = error as? SystemModule.Variable.Edit.UseCase.Error {
            return VariableEditErrorAdapter(error: error)
        }
        if let error = error as? SystemModule.Permission.Model.Error {
            return PermissionModelErrorAdapter(error: error)
        }
        if let error = error as? SystemModule.Variable.Model.Error {
            return VariableModelErrorAdapter(error: error)
        }
        return nil
    }
}
