class ImageListController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
  end 

  def viewWillAppear(animated)
    navigationItem.title = 'Locations' 
    navigationItem.rightBarButtonItem = editButtonItem
    #navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addImageItem')
    5.times do 
      addImageItem
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    imageItem = @items[indexPath.row]
    cell.textLabel.text = imageItem
    cell.image = load_picture_from imageItem
    cell
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    @items.delete_at(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    view.reloadData
  end

  def load_picture_from url
    url = NSURL.URLWithString(url)
    image = UIImage.imageWithData(NSData.dataWithContentsOfURL(url))
  end

  def setItems items
    @items = items
  end

  private

  def addImageItem
    url = "http://i.imgur.com/bbg8Y.jpg"
    @items << url
    view.reloadData
  end

end
