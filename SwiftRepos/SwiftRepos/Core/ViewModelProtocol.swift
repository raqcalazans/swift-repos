import Foundation
import RxSwift
import RxCocoa

/// A protocol that defines the base structure for all ViewModels in the application.
/// It establishes a clear contract for the unidirectional data flow (MVI).
protocol ViewModelProtocol {
    /// The type that represents the View's state (e.g., `RepositoryListState`).
    associatedtype State
    
    /// The type that represents user actions or View events (e.g., `RepositoryListIntent`).
    associatedtype Intent
    
    /// The state output from the ViewModel. The View observes this Driver to update itself.
    var state: Driver<State> { get }
    
    /// The action input for the ViewModel. The View sends Intents to this Relay.
    var intent: PublishRelay<Intent> { get }
}
