//
//  FirstNewsViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
//import SkeletonView

private let ReuseIdentifier: String = "CellReuseIdentifier"

class FirstNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MainViewControllerDelegate?
    var languageCode: String = ""
    
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    var pageIndex: Int!
    private var articleUrl = [String]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier)

        //populateNews()
        
    }
    
    //MARK: - Helpers
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func populateNews() {
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=\(languageCode)&apiKey=9c7f5dac95da4230899a5d6edb22adaa")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate/DataSource

extension FirstNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let url = URL(string: self.articleUrl[indexPath.row]) {
//            UIApplication.shared.open(url)
//        }

        guard let url = URL(string: self.articleUrl[indexPath.row]) else { return }
        delegate?.SafariServicesOpen(url: url)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FirstNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.articlesVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)

        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)

//        cell.titleLabel.hideSkeleton()
        
        articleVM.publishedAt.bind { (date) in
            cell.dateLabel.text = date.utcToLocal()
//            cell.dateLabel.hideSkeleton()
        }.disposed(by: disposeBag)
        
        articleVM.urlToImage.bind { (url) in
            let url = URL(string: url)
            cell.articleImageView.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        articleVM.url.bind { (url) in
            self.articleUrl.append(url)
        }.disposed(by: disposeBag)
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        return cell
    }
}
