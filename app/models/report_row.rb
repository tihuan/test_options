class ReportRow < ActiveRecord::Base
  belongs_to :report

  after_initialize :set_headers_array, :set_col_counts, :set_content_array, :set_header_indices

  attr_reader :headers_array, :col_counts, :header_indices, :content_array

  def update(data)
    set_content data
  end

  private

  def set_headers_array
    @headers_array = JSON.parse headers
  end

  def set_col_counts
    @col_counts = headers_array.count
  end

  def set_content(data)
    content_data = Array.new(col_counts, '')

    data.each do |key, value|
      key = key.to_sym
      index = header_indices[key]
      content_data[index] = value
    end

    save_content content_data
  end

  def save_content(content_data)
    self.content = content_data.to_json
    self.save
  end

  def set_content_array
    @content_array = JSON.parse content
  end

  def set_header_indices
    @header_indices = headers_array.each_with_index.each_with_object({}) do |header_index_pair, memo|
      header, index = header_index_pair
      memo[header.to_sym] = index
    end
  end
end
