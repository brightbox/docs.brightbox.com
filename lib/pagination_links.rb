module PaginationLinks
  # Generates the URL to the next page, given the # of the current page.
  # base_path should not include /page/x and should start & end with /
  def next_page_url page_number, base_path
    "#{base_path}page/#{page_number + 1}/"
  end

  # Generates the URL to the previous page, given the # of the current page.
  # base_path should not include /page/x and should start & end with /
  def previous_page_url page_number, base_path
    page_number <= 2 ? base_path : "#{base_path}page/#{page_number - 1}/"
  end
end
