import UIKit

class HirooGakuenViewController: UIViewController {
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var autoScrollTimer: Timer?   // ⬅️ Added
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 239/255, alpha: 1)
        title = "広尾学園"
        
        setupImageCarousel()
        setupButtons()
        startAutoScroll() // ⬅️ Start auto switching
    }
    
    private func setupImageCarousel() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: 280) // bigger image
        ])
        
        let images = ["1.JPG", "2.JPG"]
        for (index, name) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.frame = CGRect(
                x: CGFloat(index) * (view.frame.width - 40),
                y: 0,
                width: view.frame.width - 40,
                height: 280
            )
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(
            width: (view.frame.width - 40) * CGFloat(images.count),
            height: 280
        )
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Auto Scroll
    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let pageWidth = self.scrollView.frame.width
            let maxWidth = pageWidth * CGFloat(self.pageControl.numberOfPages)
            let contentOffset = self.scrollView.contentOffset.x
            
            var nextOffset = contentOffset + pageWidth
            if nextOffset >= maxWidth { // loop back
                nextOffset = 0
            }
            
            self.scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoScrollTimer?.invalidate() // stop timer when leaving
    }
    
    // MARK: - Festival Buttons
    private func setupButtons() {
        let missingButton = makeFestivalButton(title: "Missing", systemImage: "person.fill.questionmark", action: #selector(openMissing), color: .systemPink)
        let mapButton = makeFestivalButton(title: "Map", systemImage: "map.fill", action: #selector(openMap), color: .systemBlue)
        let congestionButton = makeFestivalButton(title: "Congestion", systemImage: "car.fill", action: #selector(openCongestion), color: .systemOrange)
        let timetableButton = makeFestivalButton(title: "TimeTable", systemImage: "calendar", action: #selector(openTimetable), color: .systemGreen)
        
        // Grid layout (2x2)
        let grid = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [missingButton, mapButton]),
            UIStackView(arrangedSubviews: [congestionButton, timetableButton])
        ])
        grid.axis = .vertical
        grid.spacing = 20
        
        for row in grid.arrangedSubviews as! [UIStackView] {
            row.axis = .horizontal
            row.spacing = 20
            row.distribution = .fillEqually
        }
        
        view.addSubview(grid)
        grid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 80),
            grid.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func makeFestivalButton(title: String, systemImage: String, action: Selector, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        
        // Icon + Title stacked vertically
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.baseBackgroundColor = color
        config.cornerStyle = .large
        
        button.configuration = config
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Square shape
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        // Shadow for "festival poster" feel
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        
        // Bounce animation
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.1,
                           animations: {
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 6,
                               options: .allowUserInteraction,
                               animations: {
                    button.transform = .identity
                }, completion: nil)
            })
            
            self.perform(action)
        }, for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Navigation Actions
    @objc private func openMissing() {
        navigationController?.pushViewController(MissingPersonViewController(), animated: true)
    }
    
    @objc private func openMap() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
    @objc private func openCongestion() {
    }
    
    @objc private func openTimetable() {
        navigationController?.pushViewController(TimeTableViewController(), animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension HirooGakuenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / (view.frame.width - 40))
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - Dummy ViewControllers
class MissingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        title = "Missing"
    }
    
    class MapViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBlue
            title = "Map"
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
    }
}
