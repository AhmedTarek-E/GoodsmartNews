//
//  NewsFeedViewController.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit
import RxSwift
import SVProgressHUD

class NewsFeedViewController: UIViewController {
    
    static let sectionHeaderKind = "sectionHeaderKind"
    
    static func create() -> NewsFeedViewController {
        let vc = NewsFeedViewController(
            nibName: String(describing: self),
            bundle: Bundle(for: self)
        )
        vc.viewModel = DiContainer.getNewsFeedViewModel()
        return vc
    }
    
    private var viewModel: NewsFeedViewModel!
    private let disposeBag = DisposeBag()
    
    private var stockTickers: [StockTicker] = []
    private var latestNews: [Article] = []
    private var moreNews: [Article] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.state.observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] state in
                self?.renderState(state: state)
            } onError: { [weak self] error in
                self?.showError(error: "Something went wrong")
            }
            .disposed(by: disposeBag)

        viewModel.effect.observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] effect in
                self?.handleEffect(effect: effect)
            } onError: { [weak self] error in
                self?.showError(error: "Something went wrong")
            }
            .disposed(by: disposeBag)

        setupCollectionView()
        setupNavBar()
        
        viewModel.loadData()
    }
    
    private func setupNavBar() {
        navigationItem.title = "News Feed"
    }
    
    private func renderState(state: NewsFeedState) {
        handleLoading(state: state)
        handleDisplayData(state: state)
        handleFailure(state: state)
    }
    
    private func handleLoading(state: NewsFeedState) {
        if state.news == .loading || state.stockTickers == .loading {
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
            }
        } else {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func handleDisplayData(state: NewsFeedState) {
        switch (state.news, state.stockTickers) {
        case (.success, .success(let stockTickers)):
            self.stockTickers = stockTickers
            self.latestNews = state.latestNews
            self.moreNews = state.verticalNews
            
            collectionView.reloadData()
        default:
            break
        }
    }
    
    private func handleFailure(state: NewsFeedState) {
        //TODO: 
    }
    
    private func handleEffect(effect: NewsFeedEffect) {
        switch effect {
        case .showError(let message):
            showError(error: message)
        }
    }

}

//Collection setup
extension NewsFeedViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = generateCollectionViewLayout()
        registerCellsAndViews()
    }
    
    private func registerCellsAndViews() {
        collectionView.register(
            UINib(
                nibName: StockTickerCell.className,
                bundle: Bundle(for: StockTickerCell.self)
            ),
            forCellWithReuseIdentifier: StockTickerCell.identifier
        )
        collectionView.register(
            UINib(
                nibName: LatestNewsCell.className,
                bundle: Bundle(for: LatestNewsCell.self)
            ),
            forCellWithReuseIdentifier: LatestNewsCell.identifier
        )
        collectionView.register(
            UINib(
                nibName: MoreNewsCell.className,
                bundle: Bundle(for: MoreNewsCell.self)
            ),
            forCellWithReuseIdentifier: MoreNewsCell.identifier
        )
        collectionView.register(
            UINib(
                nibName: "NewsFeedHeaderView",
                bundle: Bundle(for: NewsFeedHeaderView.self)
            ),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: NewsFeedHeaderView.self)
        )
    }
    
    private func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            
            let section = NewsFeedSection.allCases[sectionIndex]
            switch section {
            case .stocks:
                return self?.generateStocksLayout()
            case .latestNews:
                return self?.generateLatestNewsLayout()
            case .moreNews:
                return self?.generateMoreNewsLayout()
            }
        }
        
        return layout
    }
    
    private func generateStocksLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/4),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.1),
            heightDimension: .estimated(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 4
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let header = generateHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return section
    }
    
    private func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(32)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
    
    private func generateLatestNewsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/1.25),
            heightDimension: .fractionalWidth(5/9)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
        
        let header = generateHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8)
        return section
    }
    
    private func generateMoreNewsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1.1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let header = generateHeader()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 24
        return section
    }
}

//Collection delegate and dataSource
extension NewsFeedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if stockTickers.isEmpty || latestNews.isEmpty {
            return 0
        }
        return NewsFeedSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = NewsFeedSection.allCases[section]
        switch section {
        case .stocks:
            return stockTickers.count
        case .latestNews:
            return latestNews.count
        case .moreNews:
            return moreNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = NewsFeedSection.allCases[indexPath.section]
        switch section {
        case .stocks:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StockTickerCell.identifier,
                for: indexPath
            ) as! StockTickerCell
            cell.bind(stock: stockTickers[indexPath.row])
            return cell
        case .latestNews:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LatestNewsCell.identifier,
                for: indexPath
            ) as! LatestNewsCell
            cell.bind(article: latestNews[indexPath.row])
            return cell
        case .moreNews:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoreNewsCell.identifier,
                for: indexPath
            ) as! MoreNewsCell
            cell.bind(article: moreNews[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: NewsFeedHeaderView.self),
            for: indexPath
        )
        
        if let view = view as? NewsFeedHeaderView {
            let title = NewsFeedSection.allCases[indexPath.section].title
            view.bind(title: title)
        }
        
        return view
    }
    
    
}
