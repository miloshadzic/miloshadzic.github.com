require 'redcarpet'
require 'yaml'

BOOK_COMMENT_PATH='comments'

class ReadingList
  attr_reader :books

  def initialize(yaml_file)
    booklist = YAML::load_file(yaml_file)

    @books = []
    booklist.each do |book|
      @books << Book.new(book)
    end
  end

  def finished_books
    @books.reject { |book| book.status =~ /in progress/i }
  end

  def in_progress_books
    @books.select { |book| book.status =~ /in progress/i }
  end
end


class Book
  attr_reader :title, :isbn, :amazon_url, :start_date, :status, :comment

  def initialize(book)
    @title       = book['title']
    @authors     = split_authors(book['author'])
    @isbn        = book['isbn']
    @amazon_url  = book['url']
    @status      = book['status']
    @start_date  = book['start'].split(' ')
    @finish_date = book['finish'].split(' ') unless book['finish'].nil?

    path = File.join(BOOK_COMMENT_PATH, @title.split(' ').join('_') + '-' + @isbn.to_s + '.md')
    @comment    = BookComment.new(path)
  end

  def from_to
    if @finish_date.nil?
    elsif @start_date == @finish_date
      @start_date.join(' ')
    elsif @start_date[1] == @finish_date[1]
      "#{@start_date[0]} - #{@finish_date[0]} #{@start_date[1]}"
    else
      @start_date.join(' ') + ' - ' + @finish_date.join(' ')
    end
  end

  def authors
    if @authors.size > 1
      a = @authors[0..-2].join(', ')
      a + " and #{@authors.last}"
    else
      @authors.last
    end
  end

  private

  def split_authors(author_list)
    author_list.split(', ')
  end
end


class BookComment
  attr_reader :markdown, :html

  def initialize(path)
    `touch "#{path}"` unless File.exists?(path)
    @raw_text = File.open(path, 'r') { |f| f.read }
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       :autolink => true,
                                       :no_intra_emphasis => true,
                                       :space_after_headers => true,
                                       :superscript => true,
                                       :fenced_code_blocks => true)
    @html     = @markdown.render(@raw_text)
  end

  def markdown
    @raw_text
  end

end
