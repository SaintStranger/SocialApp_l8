//
//  News4ViewController.swift
//  SocialApp
//
//  Created by test on 31.05.2022.
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableNews: [Item]?
    
    var parser = VkPostParser()
    
    var nextFrom = ""
    
    var isLoading = false
    
    var photoToCacheSaver: PhotoToCacheSaver?
    
    private var lastDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoToCacheSaver = PhotoToCacheSaver(container: tableView)
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.identifier)

        tableView.register(NewsTextTableViewCell.self, forCellReuseIdentifier: NewsTextTableViewCell.identifier)

        tableView.register(NewsImageTableViewCell.self, forCellReuseIdentifier: NewsImageTableViewCell.identifier)
        
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        parser.getNews(table: tableView, url: parser.urlForNews()) { result, nextFrom  in
            self.tableNews = result
            self.nextFrom = nextFrom
            if result.first != nil {
                self.lastDateString = String(result.first!.date)
            }
            print(self.tableNews?.count ?? 0)
        } onError: { error in
            print(error)
        }
        
        setupRefreshControl()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RedrawCell), name: Notification.Name(rawValue: "RedrawCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RedrawCell), name: Notification.Name(rawValue: "OpenCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RedrawCell), name: Notification.Name(rawValue: "CloseCell"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "RedrawCell"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OpenCell"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "CloseCell"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    


}


extension NewsController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(self.tableNews ?? "")
        
        guard tableNews != nil else { return 3 }
        
        return tableNews?.count ?? 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //MARK: Проверяем, если нет текста или картинки, то высоту ячейки делаем равной нулю
        switch indexPath.row {
        case 0:
            return 66.0
        case 1:
            guard let table = tableNews?[indexPath.section].text else { return 0.0 }
            if table.isEmpty {
                return 0.0
            }
            return UITableView.automaticDimension
        case 2:
            guard let table = tableNews?[indexPath.section].attachments?.first?.photo?.sizes.last?.url else { return 0.0 }
            if table.isEmpty {
                return 0.0
            }
            
            let width = view.frame.width
            let photo = tableNews?[indexPath.section].attachments?.first?.photo?.sizes.last
            let height = width * (photo?.aspectRatio ?? 0)
            
            return height
            
        default:
            return UITableView.automaticDimension
        }
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as? HeaderTableViewCell else { return UITableViewCell() }
            
            let date = tableNews?[indexPath.section].getStringDate()
            let name = tableNews?[indexPath.section].sourceName
            let avatar = tableNews?[indexPath.section].sourceAvatar
            
            cell.configure(date: date, name: name, photo: avatar ?? "")
            
            return cell
        } else if indexPath.row == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTextTableViewCell.identifier) as? NewsTextTableViewCell else { return UITableViewCell() }
            cell.configure(text: tableNews?[indexPath.section].text)
            return cell
            
            
        } else if indexPath.row == 2  {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsImageTableViewCell.identifier) as? NewsImageTableViewCell else { return UITableViewCell() }
            
            
            //Пропускаем фото через Cache
            let photos = tableNews?[indexPath.section].attachments
            
            var photosArray: [UIImage?] = []
            
            guard let photos = photos else { return UITableViewCell() }
            for photo in photos {
                let item = photoToCacheSaver?.photo(atIndexPath: indexPath, byUrl: photo.photo?.sizes.last?.url ?? "")
                photosArray.append(item)
            }
            
            cell.configure(photos: photosArray)
            //Отправили в ячейку
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier) as? FooterTableViewCell else { return UITableViewCell() }
            
            
            let likes = tableNews?[indexPath.section].likes.count
            let comments = tableNews?[indexPath.section].comments.count
            
            cell.configure(likes: likes, comments: comments)
            
            return cell
        }

    }
    
    fileprivate func setupRefreshControl() {
        
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        
        tableView.refreshControl?.tintColor = UIColor(red: CGFloat(137.0/255.0), green: CGFloat(207.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1)
        
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
    }
    

    @objc func refreshNews() {
        guard let date = lastDateString else {
            tableView.refreshControl?.endRefreshing()
            return
        }
        parser.getUpdatedNews(table: tableView, url: parser.urlForRecentNews(latestTime: date)) { [weak self] result  in
            
            if result.first != nil {
                self?.lastDateString = String(result.first!.date)
            }
            
            self?.tableNews?.insert(contentsOf: result, at: 0)
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
            
        } onError: { error in
            print(error)
        }


    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max(),
              let news = tableNews else { return }
        
        if maxSection > news.count - 5, !isLoading {
            self.isLoading = true
            
            parser.getNews(table: tableView, url: parser.urlForUpdationNews(from: nextFrom)) { result, nextForm  in

                self.nextFrom = nextForm
                
                guard self.tableNews != nil else  { return }
                
                let indexSet = IndexSet(integersIn: self.tableNews!.count..<self.tableNews!.count + result.count)
                self.tableNews!.append(contentsOf: result)
                self.tableView.insertSections(indexSet, with: .automatic)
                self.isLoading = false

            } onError: { error in
                print(error)
            }
        }
    }


    @objc func RedrawCell() {
        tableView.beginUpdates()

        tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)

        tableView.endUpdates()
    }
    
    
    
}


