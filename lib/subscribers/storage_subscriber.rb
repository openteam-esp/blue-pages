class StorageSubscriber
  def update_content(path)
    Subdivision.where(:info_path => path).map(&:send_update_message)

    Person.where(:info_path => path).map(&:update_info_path)
  end
end
