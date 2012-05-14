class StorageSubscriber
  def update_content(path)
    Subdivision.where(:info_path => path).map(&:send_update_message)
    Person.where(:info_path => path).map(&:item).map(&:send_update_message)
  end
end
