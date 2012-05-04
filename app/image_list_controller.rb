class ImageListController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
    @items = []
  end 

  def viewWillAppear(animated)
    navigationItem.title = 'Locations' 
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addImageItem')

    #navigationController.view.backgroundColor = UIColor.colorWithPatternImage(load_picture_from_url)
    #tableView.backgroundColor = UIColor.clearColor
  end

  def addImageItem
    url = "http://i.imgur.com/bbg8Y.jpg"
    @items << url
    view.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    imageItem = @items[indexPath.row]
    cell.textLabel.text = imageItem
    cell.image = load_picture_from_url
    cell
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    @items.delete_at(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    view.reloadData
  end

  def load_picture_from_url
    url = NSURL.URLWithString("http://i.imgur.com/bbg8Y.jpg")
    image = UIImage.imageWithData(NSData.dataWithContentsOfURL(url))
  end
end
