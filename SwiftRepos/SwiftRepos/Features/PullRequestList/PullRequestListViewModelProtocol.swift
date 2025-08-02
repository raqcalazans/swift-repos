import RxRelay
import RxCocoa

protocol PullRequestListViewModelProtocol {
    
    var intent: PublishRelay<PullRequestListIntent> { get }
    var state: Driver<PullRequestListState> { get }
    var navigation: Signal<PullRequestListNavigation> { get }
}
