//
//  HirooGakuenViewController.swift
//  Hiroo App
//
//  Created by ard on 2025/06/05.
//

import UIKit

class HirooGakuenViewController: UIViewController {
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageControl = UIPageControl()
    private let buttonGrid = UIStackView()
    
    private let images = ["1.JPG", "1.1.png"] // your images
    private var timer: Timer? // slideshow timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "広尾学園"
        
        setupImageCarousel()
        setupButtons()
        startAutoSlide() // 🔥 start slideshow
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate() // stop when leaving screen
    }
    
    // MARK: - Image Carousel
    private func setupImageCarousel() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for name in images {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 24
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Auto Slide
    private func startAutoSlide() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let nextPage = (self.pageControl.currentPage + 1) % self.images.count
            let offsetX = CGFloat(nextPage) * self.scrollView.frame.width
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            self.pageControl.currentPage = nextPage
        }
    }
    
    // MARK: - Buttons
    private func setupButtons() {
        let missingButton = makeGameButton(title: "Missing", color: .systemPink, action: #selector(openMissing))
        let mapButton = makeGameButton(title: "Map", color: .systemBlue, action: #selector(openMap))
        let congestionButton = makeGameButton(title: "Congestion", color: .systemOrange, action: #selector(openCongestion))
        let timetableButton = makeGameButton(title: "TimeTable", color: .systemGreen, action: #selector(openTimetable))
        
        let topRow = UIStackView(arrangedSubviews: [missingButton, mapButton])
        topRow.axis = .horizontal
        topRow.alignment = .fill
        topRow.distribution = .fillEqually
        topRow.spacing = 24
        
        let bottomRow = UIStackView(arrangedSubviews: [congestionButton, timetableButton])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .fill
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 24
        
        buttonGrid.axis = .vertical
        buttonGrid.alignment = .fill
        buttonGrid.spacing = 28
        buttonGrid.addArrangedSubview(topRow)
        buttonGrid.addArrangedSubview(bottomRow)
        
        view.addSubview(buttonGrid)
        buttonGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonGrid.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 80),
            buttonGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func makeGameButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 24
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 8
        button.heightAnchor.constraint(equalToConstant: 120).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: - Navigation Actions
    @objc private func openMissing() {
        navigationController?.pushViewController(MissingViewController(), animated: true)
    }
    
    @objc private func openMap() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
    @objc private func openCongestion() {
        navigationController?.pushViewController(CongestionViewController(), animated: true)
    }
    
    @objc private func openTimetable() {
        navigationController?.pushViewController(TimeTableViewController(), animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension HirooGakuenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        guard pageWidth > 0 else { return }
        let pageIndex = Int(round(scrollView.contentOffset.x / pageWidth))
        pageControl.currentPage = max(0, min(pageIndex, pageControl.numberOfPages - 1))
    }
}

// MARK: - Dummy ViewControllers
class MissingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        title = "Missing"
    }
}

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        title = "Map"
    }
}

class CongestionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Congestion"
    }
}

class TimeTableViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "TimeTable"
    }
}

