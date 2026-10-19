public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeGetPublicForm() -> GetPublicForm {
        .init(transaction: formTransaction())
    }
}
