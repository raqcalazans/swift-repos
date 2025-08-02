import RxRelay
import RxCocoa

protocol RepositoryListViewModelProtocol {
    
    var intent: PublishRelay<RepositoryListIntent> { get }
    var state: Driver<RepositoryListState> { get }
    var navigation: Signal<RepositoryListNavigation> { get }
}
