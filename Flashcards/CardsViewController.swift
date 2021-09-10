//
//  CardsViewController.swift
//  FlashcardsUITests
//
//  Created by Julie Connors on 9/8/21.
//

import UIKit

protocol CollectionDelegate {
    var cardCollection: [Card] { get set }
}

class CardsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    var viewModel: CardCollectionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM()
        configureCollection()

    }
    
    func setUpVM() {
        viewModel = CardCollectionViewModel()
        
        let setCompletion = { [self] in
            self.setCards()
        }
        
        viewModel?.bind(completion: setCompletion)
    }
    
    func setCards() {
        collectionView.reloadData()
    }
    
    func configureCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CardCell.identifier, bundle: nil), forCellWithReuseIdentifier: CardCell.identifier)
    }
}

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.number ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            fatalError()
        }
        
        let card = viewModel?.setCard(at: indexPath.row)
        
        cell.headline.text = card?.headline
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let card = viewModel?.setCard(at: indexPath.row) else { return }
        
        let cardSB = UIStoryboard(name: "Cards", bundle: nil)
        guard let popupVC = cardSB.instantiateViewController(identifier: "CardBackVC") as? CardBackViewController else { return }
        popupVC.collectionViewModel = viewModel
        popupVC.cardViewModel = CardViewModel(card: card)
        popupVC.modalPresentationStyle = .popover

        present(popupVC, animated: true, completion: nil)
    }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 90, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

extension CardsViewController: CollectionDelegate {
    var cardCollection: [Card] {
        get {
            guard let cards = viewModel?.cardVM else {fatalError()}
            return cards
        }
        set(newValue) {
            viewModel?.cardVM = newValue
        }
    }
}
