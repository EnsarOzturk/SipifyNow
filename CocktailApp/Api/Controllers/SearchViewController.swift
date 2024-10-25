//
//  SearchViewController.swift
//  CocktailApp
//
//  Created by Ensar on 25.12.2023.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: SearchViewModel!
    let network = NetworkManager()
    private var viewStyle: ListViewStyle = .small
    private var previousScrollOffset: CGFloat = 0.0

       override func viewDidLoad() {
           super.viewDidLoad()
           setupViewModel()
           setupCollectionView()
           setupSearchController()
           configureNavigationBar()
           fetchCocktails(for: "")
       }
    
    private func setupViewModel() {
        viewModel = SearchViewModel(networkManager: network)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        collectionView.register(UINib(nibName: "SearchListCell", bundle: nil), forCellWithReuseIdentifier: SearchListCell.identifier)
        collectionView.register(UINib(nibName: "SmallCardCell", bundle: nil), forCellWithReuseIdentifier: SmallCardCell.identifier)
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Cocktails"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.backgroundColor = .white
        navigationItem.searchController = searchController
    }

    private func fetchCocktails(for searchQuery: String) {
        viewModel.fetchCocktails(searchQuery: searchQuery) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching cocktails: \(error)")
            }
        }
    }

    private func configureNavigationBar() {
        title = "Search Cocktails"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "BigCard"), style: .plain, target: self, action: #selector(viewStyleButtonTapped(_:)))
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.tintColor = .black
    }

       @IBAction func viewStyleButtonTapped(_ sender: UIBarButtonItem) {
           viewModel.toggleViewStyle()
           collectionView.reloadData()
           sender.image = viewModel.viewStyle == .big ? UIImage(named: "BigCard") : UIImage(named: "SmallCard")
           if viewModel.viewStyle == .small {
                  sender.image = UIImage(named: "BigCard")
              } else {
                  sender.image = UIImage(named: "SmallCard")
            }
       }
   }

   extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return viewModel.numberOfItems
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cellIdentifier = viewModel.viewStyle == .big ? SearchListCell.identifier : SmallCardCell.identifier
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? UICollectionViewCell else {
               fatalError("Unable to dequeue cell")
           }
               
           let cocktail = viewModel.getCocktail(at: indexPath.item)
           if let searchListCell = cell as? SearchListCell {
               searchListCell.configure(with: cocktail)
           } else if let smallCardCell = cell as? SmallCardCell {
               smallCardCell.configure(with: cocktail)
           }
               
           return cell
       }
       
       
           func showDetailViewController(with drinkId: String) {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                   detailVC.cocktailId = drinkId
                   navigationController?.pushViewController(detailVC, animated: true)
               }
           }

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedCocktail = viewModel.getCocktail(at: indexPath.item)
           showDetailViewController(with: selectedCocktail.idDrink)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           switch viewModel.viewStyle {
           case .big:
               let width = (UIScreen.main.bounds.width - 24) / 2
               let height = width / 2 * 3
               return CGSize(width: width, height: height)
           case .small:
               let width = (UIScreen.main.bounds.width - 32) / 3
               let height = width / 2 * 3
               return CGSize(width: width, height: height)
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 8
          }
   }

   extension SearchViewController: UISearchResultsUpdating {
       func updateSearchResults(for searchController: UISearchController) {
           guard let searchText = searchController.searchBar.text else { return }
           viewModel.filterCocktailsForSearchText(searchText)
           fetchCocktails(for: searchText)
    }
}
