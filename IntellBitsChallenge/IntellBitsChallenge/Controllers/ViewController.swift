//
//  ViewController.swift
//  IntellBitsChallenge
//
//  Created by Julio Rico on 20/10/22.
//
import FlickerImages
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    private let refreshControl = UIRefreshControl()
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    
    private let cellIdentifier = "CollectionCell"
    private let itemsPerRow: CGFloat = 3
    private var flickDataModel: FlickerImagesDataModel?
    private var flickImages: [FlickerImage] = []
    private var itemsPerPage = 20
    private var currentPage = 1
    private var isLoading = false
    private let apiHelper = APIClientHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - View Setup
    func setUpView() {
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor.black.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        searchField.delegate = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // MARK: - Refresh
    @IBAction func refresh() {
        getDataUsing(keyWord: searchField.text)
    }
    
    // MARK: - API Calls
    func downloadDataAsync(loader: RemoteFlickerFeedLoader) async throws -> FlickerImagesDataModel? {
        try await withCheckedThrowingContinuation({ continuation in
            loader.load { result in
                continuation.resume(with: result)
            }
        })
    }
    
    func getDataUsing(keyWord: String?, resetData: Bool = false) {
        Task {
            if let keyWord, !keyWord.isEmpty {
                beginLoading()
                let testServerURL = apiHelper.createURL(from: K.FLICKR_API_IMAGE_PREFIX, keyword: keyWord, itemsPerPage: itemsPerPage, currentPage: currentPage, apiKey: FlickerImages.K.FLICKR_API)
                
                let client = URLSessionHTTPClient(session: URLSession(configuration: .default))
                let loader = RemoteFlickerFeedLoader(url: testServerURL, client: client)
                
                if let data = try? await downloadDataAsync(loader: loader) {
                    handleDownloadedData(data: data, resetData: resetData)
                    collectionView.reloadData()
                }
                
                completeLoading()
            }
        }
    }
    
    func handleDownloadedData(data: FlickerImagesDataModel, resetData: Bool) {
        flickDataModel = data
        if resetData {
            flickImages.removeAll()
        }
        if flickImages.count == 0 {
            flickImages = data.photo
        } else {
            flickImages.insert(contentsOf: data.photo, at: flickImages.count - 1)
        }
    }
    
    func beginLoading() {
        isLoading = true
        refreshControl.beginRefreshing()
    }
    
    func completeLoading() {
        refreshControl.endRefreshing()
        isLoading = false
    }
    
    
    func updatePaging() {
        currentPage += 1
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if apiHelper.canGetMoreImages(for: indexPath.row, elementsInArray: flickImages.count, maxPageSize: flickDataModel?.pages, currentPage: currentPage, isLoading: isLoading) {
            updatePaging()
            getDataUsing(keyWord: searchField.text)
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        flickImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FlickrCollectionViewCell
        cell.configure(viewModel: flickImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: flickImages[indexPath.row].imageURL(imageSize: .c)) {
            UIApplication.shared.open(url)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getDataUsing(keyWord: textField.text, resetData: true)
        return true
    }
}
